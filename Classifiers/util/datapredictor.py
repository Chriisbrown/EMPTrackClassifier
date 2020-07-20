import util_funcs

def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("Classifier.pkl")
    GBDT_parameters = ["LogChi","LogChirphi", "LogChirz","LogBendChi", "trk_nstub",
                        "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3",
                        "disk4","disk5","BigInvR","TanL","ModZ","dtot","ltot"]

    return (GBDT,GBDT_parameters)

GBDT,GBDT_parameters = loadmodelGBDT()

events = util_funcs.loadDataSingleFile("hybrid10kv11.root",10,bit=True)
GBDT_predictions  = []

for i,event in enumerate(events):


    #print(event[["LogChi","LogBendChi","LogChirphi","LogChirz", "trk_nstub",
    #            "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3","disk4","disk5","BigInvR","TanL","ModZ","dtot","ltot"]])
    prediction = 1 - GBDT.predict_proba(event[GBDT_parameters].to_numpy())[:,1]
    #prediction = (prediction/max(prediction))*(2**11-1)
    for pred in prediction:
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


        