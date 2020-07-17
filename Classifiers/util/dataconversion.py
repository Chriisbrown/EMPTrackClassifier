import util_funcs
import Formats

events = util_funcs.loadDataSingleFile("hybrid10kv11.root",10,bit=True)
linked_events = []
for i,event in enumerate(events):


    #print(event[["LogChi","LogBendChi","LogChirphi","LogChirz", "trk_nstub",
    #            "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3","disk4","disk5","BigInvR","TanL","ModZ","dtot","ltot"]])
    
    Formats.random_Track()
    event = Formats.assignLinksRandom(event, nlinks=1)
    linked_events.append(event)
    
Formats.writepfile("input.txt", linked_events, nlinks=1, emptylinks_valid=True)



    
