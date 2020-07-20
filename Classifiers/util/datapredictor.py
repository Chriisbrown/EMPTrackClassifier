import util_funcs
import codecs
import numpy as np




def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("Classifier.pkl")
    GBDT_parameters = ["LogChi","LogChirphi", "LogChirz","LogBendChi", "trk_nstub",
                        "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3",
                        "disk4","disk5","BigInvR","TanL","ModZ","dtot","ltot"]

    return (GBDT,GBDT_parameters)

GBDT,GBDT_parameters = loadmodelGBDT()
GBDT_predictions = []

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

        val1 = link1.partition("v")[0]
        data1 = link1.partition("v")[2].rstrip()

        binary_input = binary(data1)
        binary_input = binary_input.replace(" ", "")
        

        LogChi = binary_input[0:7]
        LogBendChi = binary_input[8:15]
        LogChirphi = binary_input[16:23]
        LogChirz = binary_input[24:31]
        trk_nstub = binary_input[32:34]
        layer1 = binary_input[35]
        layer2 = binary_input[36]
        layer3 = binary_input[37]
        layer4 =binary_input[38]
        layer5 = binary_input[39]
        layer6 = binary_input[40]
        disk1 =binary_input[41]
        disk2 = binary_input[42]
        disk3 =binary_input[43]
        disk4 =binary_input[44]
        disk5 =binary_input[45]
        BigInvR = binary_input[46:48]
        TanL = binary_input[49:51]
        ModZ = binary_input[52:54]
        dtot = binary_input[55:57]
        ltot = binary_input[58:60]

        in_array = np.array([int(LogChi,8),int(LogBendChi,8),int(LogChirphi,8),int(LogChirz,8),
                             int(trk_nstub,3),int(layer1),int(layer2),int(layer3),int(layer4),
                             int(layer5),int(layer6),int(disk1),int(disk2),int(disk3),
                             int(disk4),int(disk5),int(BigInvR,3),int(TanL,3),int(ModZ,3),int(dtot,3),int(ltot,3)])

        in_array = np.expand_dims(in_array,axis=0)


        


        pred= 1- GBDT.predict_proba(in_array)[:,1]

        

        if val1:
            print(in_array)

            GBDT_predictions.append(pred)

file1 = open('output.txt', 'r') 
Lines = file1.readlines() 
  
GBDT_sim = []
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

        if val1:
            GBDT_sim.append(int(data1,16)/(2**12-1))


        

for i in range(len(GBDT_sim)):
    print("FPGA:",GBDT_sim[i],"\tCPU:",GBDT_predictions[i])


  