import util_funcs
import DualLinkFormat
import xgboost as xgb

def loadmodelGBDT():
    import joblib
    GBDT = joblib.load("/home/cb719/Documents/Trained_models/GBDTpredlayersv1.pkl")
    GBDT_parameters = ["LogChi","LogBendChi","LogChirphi", "LogChirz", "trk_nstub",
                        "pred_layer1","pred_layer2","pred_layer3","pred_layer4","pred_layer5","pred_layer6","pred_disk1","pred_disk2","pred_disk3",
                        "pred_disk4","pred_disk5","BigInvR","TanL","ModZ","pred_dtot","pred_ltot"]

    return (GBDT,GBDT_parameters)

events = util_funcs.loadDataSingleFile("/home/cb719/Documents/TrackFinder/Data/hybrid10kv11.root",10)
linked_events = []

GBDT,GBDT_parameters = loadmodelGBDT()

for i,event in enumerate(events):

    
    sample_event = util_funcs.resample_event(event)
    print("length of event",len(sample_event))
    if len(sample_event) > 0:
        pred = GBDT.predict(xgb.DMatrix(sample_event[GBDT_parameters].to_numpy(),label=sample_event["trk_fake"].to_numpy()))
        bit_event = util_funcs.bitdata(sample_event)

        sample_event = DualLinkFormat.assignLinksRandom(bit_event, nlinks=2)
        linked_events.append(sample_event)
        print(pred,sample_event["trk_fake"])
    
DualLinkFormat.writepfile("input.txt", linked_events, nlinks=2, emptylinks_valid=True)


    
