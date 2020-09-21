import util_funcs
import codecs
import numpy as np
import bitstring as bs
import xgboost as xgb

from scipy.special import expit

import sys

index_num = int(sys.argv[1])




def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("Models/GBDTnolog.pkl")
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

        BigInvR = (binary_input1[49:64].int)/(2**7)
       #phi = (binary_input1[37:49].int)
        TanL = (binary_input1[21:37].int)
  

        z0 =   (binary_input1[9:21].int)/(2**7)

        #do = (binary_input2[51:64].int)
        bendchi = (binary_input2[39:51].int)/(2**7)
        hitmask = (binary_input2[32:39].uint)
        chi2rz = (binary_input2[20:32].int)/(2**7)
        chi2rphi = (binary_input2[8:20].int)/(2**7)
        
            
        trk_fake = int(binary_input2[7])
        
        chi2 = chi2rz + chi2rphi


        [layer1,layer2,layer3,layer4,
         layer5,layer6,disk1,disk2,disk3,
         disk4,disk5,pred_dtot,
         pred_ltot,pred_nstub] = util_funcs.single_predhitpattern(hitmask,TanL)

        TanL = TanL/(2**7)
      
        in_array = np.array([chi2,bendchi,chi2rphi,chi2rz,
                                pred_nstub,layer1,layer2,layer3,layer4,
                                layer5,layer6,disk1,disk2,disk3,
                                disk4,disk5,BigInvR,TanL,z0,pred_dtot,pred_ltot])


        in_array = np.expand_dims(in_array,axis=0)

        #pred= GBDT.predict(xgb.DMatrix(in_array,label=None))
        pred = GBDT.predict_proba(in_array)[:,1]

        #pred = in_array[:,index_num]

        #if (val1 == '1'):
            #print(disk4,'|',disk5,'|',TanL)

        GBDT_predictions.append(pred[0])
        Target.append(trk_fake)

        GBDT_valid.append(val1)

GBDT_sim = []
GBDT_simvalid = []


file1 = open('output.txt', 'r') 
Lines = file1.readlines() 


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


        b = ((a[52:64].int))/2**7
        

        b = expit(b)

        #if (val1 == '1'):
        GBDT_sim.append(b)
        GBDT_simvalid.append(val1)
        

full_precision_GBDT = []
import pandas as pd
df = pd.read_csv("full_precision_input.csv",names=GBDT_parameters+["trk_fake"])

for i,row in df.iterrows():
    #full_precision_GBDT.append(row[index_num])
    full_precision_GBDT.append(GBDT.predict_proba(row[0:21])[:,1][0])  




diff = []
diff2 = []
with open("predictions.txt", "w") as the_file:
    for i in range(len(GBDT_sim)):
        if i > 100:
            break
        diff.append((GBDT_predictions[i] - GBDT_sim[i])**2)
        diff2.append((GBDT_predictions[i]- full_precision_GBDT[i])**2)
        #print(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i][0])
        #the_file.write(str(i)+" FPGA:"+ str(GBDT_simvalid[i])+":"+str(GBDT_sim[i])+"\tCPU:"+str(GBDT_valid[i])+":"+str(GBDT_predictions[i][0])+'\n')
        the_file.write('{0:4} FPGA: {1} : {2:8.6} \t CPU: {3} : {4:8.6} \t CPU_fullP: {5:8.6} \t,Target: {6} \n'.format(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i],full_precision_GBDT[i],Target[i]))
        #the_file.write('{0:4} FPGA: {1} : {2:8.6} \t CPU: {3} : {4:8.6} \n'.format(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i]))



print("Simulated vs Truncated CPU MSE:",np.mean(diff))
print("Full Precision vs Truncated CPU MSE:",np.mean(diff2))

