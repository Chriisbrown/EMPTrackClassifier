import pandas as pd
import os

fpga_preds = []
cpu_preds = []
synth_preds = []

for root, dirs, files in os.walk("predict_folder"):
    for file in files:
        if file.endswith(".txt"):
            inputfile = open(os.path.join(root, file), 'r') 
            inLines = inputfile .readlines() 

            for i,line in enumerate(inLines):
                    frame = line.split(":")
                    fpga_preds.append(float(frame[2].split("\t")[0]))
                    cpu_preds.append(float(frame[4].split("\t")[0]))
                    synth_preds.append(float(frame[5].split("\n")[0]))

        

data = {'FPGA_synth':fpga_preds,'CPU':cpu_preds,'Conifer':synth_preds}

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



name1 = "FPGA"
name2 = "CPU"
name3 = "Conifer"

from sklearn.metrics import roc_auc_score,roc_curve,accuracy_score,confusion_matrix
#########################################################################

fpr, tpr, thresholds =roc_curve(predictions_df["CPU_classes"] ,predictions_df["FPGA_synth"], pos_label=1)
auc = roc_auc_score(predictions_df["CPU_classes"],predictions_df["FPGA_synth"])

acc = accuracy_score(predictions_df["CPU_classes"],predictions_df["FPGA_classes"])
tn,fp,fn,tp = confusion_matrix(predictions_df["CPU_classes"],predictions_df["FPGA_classes"]).ravel()
print(name1 , " vs " , name2)

print("TN: ",tn)
print("FP: ",fp)
print("FN: ",fn)
print("TP: ",tp)
print("AUC: ",auc)
print("ACC: ",acc)

#########################################################################

fpr, tpr, thresholds =roc_curve(predictions_df["CPU_classes"] ,predictions_df["Conifer"], pos_label=1)
auc = roc_auc_score(predictions_df["CPU_classes"],predictions_df["Conifer"])

acc = accuracy_score(predictions_df["CPU_classes"],predictions_df["Conifer_classes"])
tn,fp,fn,tp = confusion_matrix(predictions_df["CPU_classes"],predictions_df["Conifer_classes"]).ravel()
print(name3 , " vs " , name2)

print("TN: ",tn)
print("FP: ",fp)
print("FN: ",fn)
print("TP: ",tp)
print("AUC: ",auc)
print("ACC: ",acc)

#########################################################################

fpr, tpr, thresholds =roc_curve(predictions_df["Conifer_classes"] ,predictions_df["FPGA_synth"], pos_label=1)
auc = roc_auc_score(predictions_df["Conifer_classes"],predictions_df["FPGA_synth"])

acc = accuracy_score(predictions_df["Conifer_classes"],predictions_df["FPGA_classes"])
tn,fp,fn,tp = confusion_matrix(predictions_df["Conifer_classes"],predictions_df["FPGA_classes"]).ravel()
print(name1 , " vs " , name3)

print("TN: ",tn)
print("FP: ",fp)
print("FN: ",fn)
print("TP: ",tp)
print("AUC: ",auc)
print("ACC: ",acc)



