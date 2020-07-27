import util_funcs
import codecs
import numpy as np
import bitstring as bs
import xgboost as xgb




def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("/home/cb719/Documents/Trained_models/GBDTpredlayersv1.pkl")
    GBDT_parameters = ["LogChi","LogBendChi","LogChirphi", "LogChirz", "trk_nstub",
                        "pred_layer1","pred_layer2","pred_layer3","pred_layer4","pred_layer5","pred_layer6","pred_disk1","pred_disk2","pred_disk3",
                        "pred_disk4","pred_disk5","BigInvR","TanL","ModZ","pred_dtot","pred_ltot"]

    return (GBDT,GBDT_parameters)

GBDT,GBDT_parameters = loadmodelGBDT()
GBDT_predictions = ['0.6483318']*15
GBDT_valid = ['0']*15

inputfile = open('input.txt', 'r') 
inLines = inputfile .readlines() 

for i,line in enumerate(inLines):
    if i > 3: 
        frame = line.partition(":")[0]

        removed_frame = line.partition(":")[2]
        removed_frame = removed_frame.partition(" ")[2]
        input_data = []
        val1 = 1
            
        for k in range(0,21):
            data = removed_frame.split(" ")[k]
            val1 *= int(data.partition("v")[0])

            data = data.partition("v")[2].rstrip()

            binary_input = bs.BitArray(hex=data)

            if k < 4:
                input_data.append((binary_input[52:64].int)/(2**6))
            else:
                input_data.append((binary_input[52:64].uint)/(2**6))

            
                
                
            
        in_array = np.array(input_data)

        in_array = np.expand_dims(in_array,axis=0)

        pred= GBDT.predict(xgb.DMatrix(in_array,label=None))


        GBDT_predictions.append(pred)
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
        

        b = (a.uint)/2**12

        

        
        

        
        GBDT_sim.append(b)
        GBDT_simvalid.append(val1)
        
        
 

with open("predictions.txt", "w") as the_file:
    for i in range(len(GBDT_predictions)):

        #print(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i][0])
        #the_file.write(str(i)+" FPGA:"+ str(GBDT_simvalid[i])+":"+str(GBDT_sim[i])+"\tCPU:"+str(GBDT_valid[i])+":"+str(GBDT_predictions[i][0])+'\n')
        the_file.write('{0:4} FPGA: {1} : {2:8.5} \t CPU: {3} : {4:8.5} \n'.format(i, GBDT_simvalid[i],GBDT_sim[i],GBDT_valid[i],GBDT_predictions[i][0]))