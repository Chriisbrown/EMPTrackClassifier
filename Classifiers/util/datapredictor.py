import util_funcs
import codecs
import numpy as np
import bitstring as bs




def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("Classifier.pkl")
    GBDT_parameters = ["LogChi","LogChirphi", "LogChirz","LogBendChi", "trk_nstub",
                        "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3",
                        "disk4","disk5","BigInvR","TanL","ModZ","dtot","ltot"]

    return (GBDT,GBDT_parameters)

GBDT,GBDT_parameters = loadmodelGBDT()
GBDT_predictions = []
GBDT_valid = []

inputfile = open('input.txt', 'r') 
inLines = inputfile .readlines() 
input_data = []
binary = lambda x: " ".join(reversed( [i+j for i,j in zip( *[ ["{0:04b}".format(int(c,16)) for c in reversed("0"+x)][n::2] for n in [1,0] ] ) ] ))
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
      
        in_array = np.array([LogChi,LogBendChi,LogChirphi,LogChirz,
                                trk_nstub,layer1,layer2,layer3,layer4,
                                layer5,layer6,disk1,disk2,disk3,
                                disk4,disk5,BigInvR,TanL,ModZ,dtot,ltot])

        in_array = np.expand_dims(in_array,axis=0)

        pred= GBDT.predict_proba(in_array)[:,1]

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
        print(a)
        b = (a.uint)/2**7
        print(b)
        
        GBDT_sim.append(b)
        GBDT_simvalid.append(val1)
        


        

for i in range(len(GBDT_sim)):
    print(i," FPGA:", GBDT_simvalid[i],":",GBDT_sim[i],"\tCPU:",GBDT_valid[i],":",GBDT_predictions[i][0])


  