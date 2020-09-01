import pandas as pd
import os

fpga_preds = []
cpu_preds = []
synth_preds = []
target_values = []

for root, dirs, files in os.walk("predict_folder"):
    for file in files:
        if file.endswith(".txt"):
            inputfile = open(os.path.join(root, file), 'r') 
            inLines = inputfile .readlines() 

            for i,line in enumerate(inLines):
                    frame = line.split(":")

                    fpga_preds.append(float(frame[2].split("\t")[0]))
                    cpu_preds.append(float(frame[4].split("\t")[0]))
                    synth_preds.append(float(frame[7].split("\t")[0]))
                    target_values.append(float(frame[8].split("\n")[0]))

        

data = {'FPGA_synth':fpga_preds,'CPU':cpu_preds,'Conifer':synth_preds,'trk_fake':target_values}

predictions_df = pd.DataFrame(data)

threshold=0.5


predictions_df["FPGA_classes"] = predictions_df["FPGA_synth"]
predictions_df["FPGA_classes"][predictions_df["FPGA_classes"]>threshold] = 1
predictions_df["FPGA_classes"][predictions_df["FPGA_classes"]<=threshold] = 0

predictions_df["CPU_classes"] = predictions_df["CPU"]
predictions_df["CPU_classes"][predictions_df["CPU_classes"]>threshold] = 1
predictions_df["CPU_classes"][predictions_df["CPU_classes"]<=threshold] = 0

predictions_df["Conifer_classes"] = predictions_df["Conifer"]
predictions_df["Conifer_classes"][predictions_df["Conifer_classes"]>threshold] = 1
predictions_df["Conifer_classes"][predictions_df["Conifer_classes"]<=threshold] = 0
#import numpy as np
#diff = np.mean(np.abs(predictions_df["FPGA_synth"] -  predictions_df["Conifer"]))
#print(diff)

name1 = "FPGA"
name2 = "CPU"
name3 = "Conifer"
name4 = "true"

from sklearn.metrics import roc_auc_score,roc_curve,accuracy_score,confusion_matrix
#########################################################################

fpr1, tpr1, thresholds =roc_curve(predictions_df["trk_fake"] ,predictions_df["FPGA_synth"], pos_label=1)
auc1 = roc_auc_score(predictions_df['trk_fake'],predictions_df["FPGA_synth"])

acc = accuracy_score(predictions_df['trk_fake'],predictions_df["FPGA_classes"])
tn,fp,fn,tp = confusion_matrix(predictions_df['trk_fake'],predictions_df["FPGA_classes"]).ravel()
print(name1 , " vs " , name4)

print("TN: ",tn)
print("FP: ",fp)
print("FN: ",fn)
print("TP: ",tp)
print("AUC: ",auc1)
print("ACC: ",acc)

#########################################################################

fpr2, tpr2, thresholds =roc_curve(predictions_df['trk_fake'] ,predictions_df["Conifer"], pos_label=1)
auc2 = roc_auc_score(predictions_df['trk_fake'],predictions_df["Conifer"])

acc = accuracy_score(predictions_df['trk_fake'],predictions_df["Conifer_classes"])
tn,fp,fn,tp = confusion_matrix(predictions_df['trk_fake'],predictions_df["Conifer_classes"]).ravel()
print(name3 , " vs " , name4)

print("TN: ",tn)
print("FP: ",fp)
print("FN: ",fn)
print("TP: ",tp)
print("AUC: ",auc2)
print("ACC: ",acc)

#########################################################################

fpr3, tpr3, thresholds =roc_curve(predictions_df['trk_fake'] ,predictions_df["CPU"], pos_label=1)
auc3 = roc_auc_score(predictions_df['trk_fake'],predictions_df["CPU"])

acc = accuracy_score(predictions_df['trk_fake'],predictions_df["CPU_classes"])
tn,fp,fn,tp = confusion_matrix(predictions_df['trk_fake'],predictions_df["CPU_classes"]).ravel()
print(name2 , " vs " , name4)

print("TN: ",tn)
print("FP: ",fp)
print("FN: ",fn)
print("TP: ",tp)
print("AUC: ",auc3)
print("ACC: ",acc)





import matplotlib.pyplot as plt
import matplotlib
import mplhep as hep
plt.style.use(hep.cms.style.ROOT)



fig, ax = plt.subplots(1,1, figsize=(9,9)) 
ax.tick_params(axis='x', labelsize=16)
ax.tick_params(axis='y', labelsize=16)

ax.set_title("Xgboost, Conifer, Csim vs true predictions ROC curves",loc='left',fontsize=20)
ax.plot(fpr1,tpr1,label="FPGA " + "AUC: %.3f"%auc1)
ax.plot(fpr2,tpr2,label="Confier " + "AUC: %.3f"%auc2)
ax.plot(fpr3,tpr3,label="CPU " + "AUC: %.3f"%auc3)
ax.set_xlim([0.0,0.3])
ax.set_ylim([0.7,1.0])
        ##ax[0].plot(fpr,fpr,"--",color='r',label="Random Guess: 0.5")
ax.set_xlabel("False Positive Rate",ha="right",x=1,fontsize=16)
ax.set_ylabel("Identification Efficiency",ha="right",y=1,fontsize=16)
ax.legend()
ax.grid()

plt.tight_layout()
plt.savefig("FPGAvsConiferAUC.png",dpi=200)



