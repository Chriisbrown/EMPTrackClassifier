import util_funcs
import DualLinkFormat

def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("Classifier.pkl")
    GBDT_parameters = ["LogChi","LogBendChi","LogChirphi", "LogChirz", "trk_nstub",
                        "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3",
                        "disk4","disk5","BigInvR","TanL","ModZ","dtot","ltot"]

    return (GBDT,GBDT_parameters)

events = util_funcs.loadDataSingleFile("hybrid10kv11.root",100,bit=True)
linked_events = []

GBDT,GBDT_parameters = loadmodelGBDT()

for i,event in enumerate(events):

    
    sample_event = util_funcs.resample_event(event)
    print("length of event",len(sample_event))
    if len(sample_event) > 0:
        pred = GBDT.predict_proba(sample_event[GBDT_parameters].to_numpy())[:,1]
        DualLinkFormat.random_Track()
        sample_event = DualLinkFormat.assignLinksRandom(sample_event, nlinks=2)
        linked_events.append(sample_event)
        print(pred)
    
DualLinkFormat.writepfile("input.txt", linked_events, nlinks=2, emptylinks_valid=True)


    
