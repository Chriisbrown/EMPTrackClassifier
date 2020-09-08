import util_funcs
import DualLinkFormat
import xgboost as xgb


import sys
import os

os.system("rm full_precision_input.csv")
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

events = util_funcs.loadDataSingleFile("/home/cb719/Documents/TrackFinder/Data/hybrid10kv11.root",[0,100])
linked_events = []

NN,NN_parameters = loadmodelNN()

for i,event in enumerate(events):
    if i % 100 == 0:
        print(i)

    sample_event = util_funcs.resample_event(event)
    

    if len(sample_event) > 0:

        pred = NN.predict(sample_event[NN_parameters].to_numpy())

        temp = NN_parameters + ["trk_fake"]
        
        sample_event.to_csv("full_precision_input.csv",columns=temp,index=False,header=False,mode='a')
        bit_event = util_funcs.bitdata(sample_event)

        sample_event = DualLinkFormat.assignLinksRandom(bit_event, nlinks=8)
        linked_events.append(sample_event)

    
DualLinkFormat.writepfile("input.txt", linked_events, nlinks=8, emptylinks_valid=True)


    
