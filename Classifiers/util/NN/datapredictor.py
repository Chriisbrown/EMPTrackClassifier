import util_funcs
import codecs
import numpy as np
import bitstring as bs


import sys

#index_num = int(sys.argv[1])



def loadmodelNN():
    from tensorflow.keras.models import load_model
    from qkeras.qlayers import QDense, QActivation
    from qkeras.quantizers import quantized_bits, quantized_relu
    from qkeras.utils import _add_supported_quantized_objects
    co = {}
    _add_supported_quantized_objects(co)

    NN = load_model("Models/NN_test.h5",custom_objects=co)

    NN_parameters = ["LogChi","LogBendChi","LogChirphi", "LogChirz", "trk_nstub",
                        "pred_layer1","pred_layer2","pred_layer3","pred_layer4","pred_layer5","pred_layer6","pred_disk1","pred_disk2","pred_disk3",
                        "pred_disk4","pred_disk5","BigInvR","TanL","ModZ","pred_dtot","pred_ltot"]

    return (NN,NN_parameters)

NN,NN_parameters = loadmodelNN()
NN_predictions = []
NN_valid = []

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
        link3 = removed_frame.split(" ")[3]
        link4 = removed_frame.split(" ")[4]
        link5 = removed_frame.split(" ")[5]
        link6 = removed_frame.split(" ")[6]
        link7 = removed_frame.split(" ")[7]
        link8 = removed_frame.split(" ")[8]

        val1 = link1.partition("v")[0]
        val2 = link2.partition("v")[0]
        val3 = link3.partition("v")[0]
        val4 = link4.partition("v")[0]
        val5 = link5.partition("v")[0]
        val6 = link6.partition("v")[0]
        val7 = link7.partition("v")[0]
        val8 = link8.partition("v")[0]

        data1 = link1.partition("v")[2].rstrip()
        data2 = link2.partition("v")[2].rstrip()
        data3 = link3.partition("v")[2].rstrip()
        data4 = link4.partition("v")[2].rstrip()
        data5 = link5.partition("v")[2].rstrip()
        data6 = link6.partition("v")[2].rstrip()
        data7 = link7.partition("v")[2].rstrip()
        data8 = link8.partition("v")[2].rstrip()


        binary_input1 = bs.BitArray(hex=data1)
        binary_input2 = bs.BitArray(hex=data2)
        binary_input3 = bs.BitArray(hex=data3)
        binary_input4 = bs.BitArray(hex=data4)
        binary_input5 = bs.BitArray(hex=data5)
        binary_input6 = bs.BitArray(hex=data6)
        binary_input7 = bs.BitArray(hex=data7)
        binary_input8 = bs.BitArray(hex=data8)
        

        LogChi =     (binary_input1[49:64].int)/(2**10)
        LogBendChi = (binary_input1[33:48].int)/(2**10)
        LogChirphi = (binary_input1[17:32].int)/(2**10)

        LogChirz =  (binary_input2[49:64].int)/(2**10)
        trk_nstub = (binary_input2[33:48].uint)/(2**10)
        layer1 =    (binary_input2[17:32].uint)/(2**10)

        layer2 = (binary_input3[49:64].uint)/(2**10)
        layer3 = (binary_input3[33:48].uint)/(2**10)
        layer4 = (binary_input3[17:32].uint)/(2**10)

        layer5 = (binary_input4[49:64].uint)/(2**10)
        layer6 = (binary_input4[33:48].uint)/(2**10)
        disk1 =  (binary_input4[17:32].uint)/(2**10)

        disk2 = (binary_input5[49:64].uint)/(2**10)
        disk3 = (binary_input5[33:48].uint)/(2**10)
        disk4 = (binary_input5[17:32].uint)/(2**10)

        disk5 =   (binary_input6[49:64].uint)/(2**10)
        BigInvR = (binary_input6[33:48].uint)/(2**10)
        TanL =    (binary_input6[17:32].uint)/(2**10)

        ModZ = (binary_input7[49:64].uint)/(2**10)
        dtot = (binary_input7[33:48].uint)/(2**10)
        ltot = (binary_input7[17:32].uint)/(2**10)

        trk_fake = int(binary_input8[63])
      
        in_array = np.array([LogChi,LogBendChi,LogChirphi,LogChirz,
                                trk_nstub,layer1,layer2,layer3,layer4,
                                layer5,layer6,disk1,disk2,disk3,
                                disk4,disk5,BigInvR,TanL,ModZ,dtot,ltot])

        in_array = np.expand_dims(in_array,axis=0)

        #pred= GBDT.predict(xgb.DMatrix(in_array,label=None))
        pred = NN.predict(in_array)
        

        #pred = in_array[:,index_num]

        if (val1 == '1') :
            NN_predictions.append(pred)
            Target.append(trk_fake)

            NN_valid.append(val1)
        

file1 = open('output.txt', 'r') 
Lines = file1.readlines() 

NN_sim = []
NN_simvalid = []
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


        b = (((a[52:64].int))/2**10)

        



        if (val1 == '1'):
            NN_sim.append(b)
            NN_simvalid.append(val1)
        

full_precision_NN = []
import pandas as pd
df = pd.read_csv("full_precision_input.csv",names=NN_parameters+["trk_fake"])

for i,row in df.iterrows():

    in_array = np.expand_dims(np.flip(row[0:21].to_numpy()),axis=0)
    full_precision_NN.append(NN.predict(in_array))  



diff = []
with open("predictions.txt", "w") as the_file:
    for i in range(len(NN_sim)):

        diff.append((full_precision_NN[i] - NN_predictions[i])**2)
        the_file.write('{0:4} FPGA: {1} : {2:8.4} \t CPU: {3} : {4:8.4} \t CPU_fullP: {5:8.4} \tTarget: {6} \n'.format(i, NN_simvalid[i],NN_sim[i],NN_valid[i],NN_predictions[i][0][0],full_precision_NN[i][0][0],Target[i]))



print("MSE:",np.mean(diff))


