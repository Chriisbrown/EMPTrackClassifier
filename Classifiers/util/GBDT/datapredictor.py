import util_funcs
import codecs
import numpy as np
import bitstring as bs
import xgboost as xgb

from scipy.special import expit

import sys

#index_num = int(sys.argv[1])




def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("Models/GBDT_test.pkl")
    GBDT_parameters = ["LogChi","LogBendChi","LogChirphi", "LogChirz", "trk_nstub",
                        "pred_layer1","pred_layer2","pred_layer3","pred_layer4","pred_layer5","pred_layer6","pred_disk1","pred_disk2","pred_disk3",
                        "pred_disk4","pred_disk5","BigInvR","TanL","ModZ","pred_dtot","pred_ltot"]

    return (GBDT,GBDT_parameters)

GBDT,GBDT_parameters = loadmodelGBDT()
GBDT_predictions = []
GBDT_valid = []

Target = []





inputfile = open('input.txt', 'r') 
inLines = inputfile .readlines() 
input_data = []
for i,line in enumerate(inLines):
    if i > 3: 
        frame = line.partition(":")[0]
        removed_frame = line.partition(":")[2]
        #val1 = removed_frame.split("v")[0]
        link1 = removed_frame.split(" ")[1]
        link2 = removed_frame.split(" ")[2]

        val1 = link1.partition("v")[0]
        val2 = link2.partition("v")[0]
        data1 = link1.partition("v")[2].rstrip()
        data2 = link2.partition("v")[2].rstrip()

 

        #print('\''+data1+'\'')
            #print('\''+data2+'\'')

        binary_input1 = bs.BitArray(hex=data1)
            #print(binary_input1.bin)
            #print(binary_input1[52:64])

        binary_input2 = bs.BitArray(hex=data2)
            #print(binary_input2.bin)
            
            
        LogChi = (binary_input1[52:64].int)/(2**7)
        LogBendChi = (binary_input1[40:52].int)/(2**7)
        LogChirphi = (binary_input1[28:40].int)/(2**7)
        LogChirz = (binary_input1[16:28].int)/(2**7)
        trk_nstub = (binary_input1[12:16].uint)
        layer1 = int(binary_input1[11])
        layer2 = int(binary_input1[10])
        layer3 = int(binary_input1[9])
        layer4 = int(binary_input1[8])
        layer5 = int(binary_input1[7])
        layer6 = int(binary_input1[6])



        disk1 = int(binary_input2[63])
        disk2 = int(binary_input2[62])
        disk3 = int(binary_input2[61])
        disk4 = int(binary_input2[60])
        disk5 = int(binary_input2[59])
        BigInvR = (binary_input2[47:59].uint)/(2**7)
        TanL = (binary_input2[35:47].uint)/(2**7)
        ModZ = (binary_input2[23:35].uint)/(2**7)
        dtot = (binary_input2[20:23].uint)
        ltot = (binary_input2[17:20].uint)

        trk_fake = int(binary_input2[16])
      
        in_array = np.array([LogChi,LogBendChi,LogChirphi,LogChirz,
                                trk_nstub,layer1,layer2,layer3,layer4,
                                layer5,layer6,disk1,disk2,disk3,
                                disk4,disk5,BigInvR,TanL,ModZ,dtot,ltot])

        in_array = np.expand_dims(in_array,axis=0)

        #pred= GBDT.predict(xgb.DMatrix(in_array,label=None))
        pred = GBDT.predict_proba(in_array)[:,1]

        #pred = in_array[:,index_num]

        if (val1 == '1') :
            GBDT_predictions.append(pred[0])
            Target.append(trk_fake)

            GBDT_valid.append(val1)
        

file1 = open('output.txt', 'r') 
Lines = file1.readlines() 

GBDT_sim = []
GBDT_simvalid = []
# Strips the newline character 
for i,line in enumerate(Lines):
    if i > 3: 
        frame = line.partition(":")[0]
        removed_frame = line.partition(":")[2]
        #val1 = removed_frame.split("v")[0]
        link1 = removed_frame.split(" ")[1]
        link2 = removed_frame.split(" ")[2]
        link3 = removed_frame.split(" ")[3]
        link4 = removed_frame.split(" ")[4]

        val1 = link1.partition("v")[0]
        data1 = link1.partition("v")[2]

        
        
        a = bs.BitArray(hex=data1)


        b = (((a[52:64].int))/2**7)

        

        b = expit(b)

        if (val1 == '1'):
            GBDT_sim.append(b)
            GBDT_simvalid.append(val1)
        

full_precision_GBDT = []
import pandas as pd
df = pd.read_csv("full_precision_input.csv",names=GBDT_parameters+["trk_fake"])

for i,row in df.iterrows():
    full_precision_GBDT.append(GBDT.predict_proba(row[0:21])[:,1][0])  



diff = []
with open("predictions.txt", "w") as the_file:
    for i in range(len(GBDT_sim)):
        diff.append((full_precision_GBDT[i] - GBDT_predictions[i])**2)
        #print(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i][0])
        #the_file.write(str(i)+" FPGA:"+ str(GBDT_simvalid[i])+":"+str(GBDT_sim[i])+"\tCPU:"+str(GBDT_valid[i])+":"+str(GBDT_predictions[i][0])+'\n')
        the_file.write('{0:4} FPGA: {1} : {2:8.4} \t CPU: {3} : {4:8.4} \t CPU_fullP: {5:8.4} \t,Target: {6} \n'.format(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i],full_precision_GBDT[i],Target[i]))



print("MSE:",np.mean(diff))

