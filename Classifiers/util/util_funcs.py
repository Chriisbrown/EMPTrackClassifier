import uproot
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pickle
import os

def pttoR(pt):
    B = 3.8112 #Tesla for CMS magnetic field

    return abs((B*(3e8/1e11))/(2*pt))

def tanL(eta):
    return abs(np.sinh(eta))

def logChi(chi2):
    return np.log(chi2)

def sum_digits3(N):
  R = np.zeros(len(N))

  for i in range(len(N)):
    n = N[i]
    r = 0
    while n:

      r, n = r + n % 10, n // 10
    R[i] = r
  return R

def nhotdisk(dataframe):

    disk = dataframe["trk_dhits"].astype(str)
    dataframe["disk1"] = np.zeros([len(disk)])
    dataframe["disk2"] = np.zeros([len(disk)])
    dataframe["disk3"] = np.zeros([len(disk)])
    dataframe["disk4"] = np.zeros([len(disk)])
    dataframe["disk5"] = np.zeros([len(disk)])

    for i in range(len(disk)):
        for k in range(len(disk[i])):
            dataframe["disk"+str(k+1)][i] = disk[i][-(k+1)]

    return(dataframe)

def nhotlayer(dataframe):
    layer = dataframe["trk_lhits"].astype(str)

    dataframe["layer1"] = np.zeros([len(layer)])
    dataframe["layer2"] = np.zeros([len(layer)])
    dataframe["layer3"] = np.zeros([len(layer)])  
    dataframe["layer4"] = np.zeros([len(layer)])
    dataframe["layer5"] = np.zeros([len(layer)])
    dataframe["layer6"] = np.zeros([len(layer)])

    for i in range(len(layer)):
        for j in range(len(layer[i])):
            dataframe["layer"+str(j+1)][i] = layer[i][-(j+1)]

    return(dataframe)

def predhitpattern(dataframe):
  

    hitpat = [str(bin(dataframe["trk_hitpattern"][i])) for i in range(len(dataframe["trk_hitpattern"]))]


    hit_array = np.zeros([7,len(hitpat)])
    expanded_hit_array = np.zeros([12,len(hitpat)])
    ltot = np.zeros(len(hitpat))
    dtot = np.zeros(len(hitpat))
    for i in range(len(hitpat)):
        for k in range(len(hitpat[i])-2):
            hit_array[k,i] = hitpat[i][-(k+1)]

    eta_bins = [0.0,0.2,0.41,0.62,0.9,1.26,1.68,2.08,2.5]
    conversion_table = np.array([[0, 1,  2,  3,  4,  5,  11],
                                 [0, 1,  2,  3,  4,  5,  11],
                                 [0, 1,  2,  3,  4,  5,  11],
                                 [0, 1,  2,  3,  4,  5,  11],
                                 [0, 1,  2,  3,  4,  5,  11],
                                 [0, 1,  2,  6,  7,  8,  9 ],
                                 [0, 1,  7,  8,  9, 10,  11],
                                 [0, 6,  7,  8,  9, 10,  11]])

    for i in range(len(hitpat)):
        #print(dataframe["trk_eta"][i])
        for j in range(8):
            if ((abs(dataframe["trk_eta"][i]) >= eta_bins[j]) & (abs(dataframe["trk_eta"][i]) < eta_bins[j+1])):
                for k in range(7):
                    expanded_hit_array[conversion_table[j][k]][i] = hit_array[k][i]


        ltot[i] = sum(expanded_hit_array[0:6,i])
        dtot[i] = sum(expanded_hit_array[6:11,i])

    
    dataframe["pred_layer1"] = expanded_hit_array[0,:]
    dataframe["pred_layer2"] = expanded_hit_array[1,:]
    dataframe["pred_layer3"] = expanded_hit_array[2,:]
    dataframe["pred_layer4"] = expanded_hit_array[3,:]
    dataframe["pred_layer5"] = expanded_hit_array[4,:]
    dataframe["pred_layer6"] = expanded_hit_array[5,:]
    dataframe["pred_disk1"] = expanded_hit_array[6,:]
    dataframe["pred_disk2"] = expanded_hit_array[7,:]
    dataframe["pred_disk3"] = expanded_hit_array[8,:]
    dataframe["pred_disk4"] = expanded_hit_array[9,:]
    dataframe["pred_disk5"] = expanded_hit_array[10,:]
    dataframe["pred_ltot"] = ltot
    dataframe["pred_dtot"] = dtot



    return dataframe

def transformData(dataframe):


    dataframe["InvR"] = pttoR(dataframe["trk_pt"])
    dataframe["BigInvR"] = 1000*dataframe["InvR"]
    dataframe["TanL"] = tanL(dataframe["trk_eta"])
    dataframe["LogChirphi"] = logChi(dataframe["trk_chi2rphi"])
    dataframe["LogChirz"] = logChi(dataframe["trk_chi2rz"])
    dataframe["LogChi"] = logChi(dataframe["trk_chi2"])
    dataframe["ModZ"] = np.abs(dataframe["trk_z0"])
    #dataframe["dtot"] = sum_digits3(dataframe["trk_dhits"])
    #dataframe["ltot"] = sum_digits3(dataframe["trk_lhits"])
    dataframe["trk_invpt"] = 1/dataframe["trk_pt"]
    dataframe["trk_matchtp_invpt"] = 1/dataframe["trk_matchtp_pt"]
    dataframe["LogBendChi"] = np.log(dataframe["trk_bendchi2"])
    #dataframe = nhotdisk(dataframe)
    #dataframe = nhotlayer(dataframe)
    dataframe = predhitpattern(dataframe)


    return dataframe

def splitter(x,int_len=5,frac_len=12):
    dec_len = frac_len-int_len

    return int(x*(2**dec_len))



def bitdata(dataframe):
  

  dataframe["BigInvR"] = (dataframe["BigInvR"]).apply(splitter)
  dataframe["TanL"] = (dataframe["TanL"]).apply(splitter)
  dataframe["LogBendChi"] =(dataframe["LogBendChi"]).apply(splitter)
  dataframe["LogChirphi"] = (dataframe["LogChirphi"]).apply(splitter)
  dataframe["LogChirz"] = (dataframe["LogChirz"]).apply(splitter)
  dataframe["LogChi"] = (dataframe["LogChi"]).apply(splitter)
  dataframe["ModZ"] = (dataframe["ModZ"]).apply(splitter)

  return dataframe




def loadDataSingleFile(filename,num,bit=False):
  """
  New method for loading training events. It assumes that only one root file is available (as a result of hadd command)
  """

  # check if filename links to a valid file
  if (not os.path.isfile(filename)):
    raise FileNotFoundError("Trying to load data from a file that does not exist: %s" % filename)

  #noevts = len(uproot.open(filename)['L1TrackNtuple/eventTree'])

  features = ["InvR", "ModZ", "TanL", "trk_chi2rphi", "trk_chi2rz", "trk_phi", "trk_bendchi2", "trk_nstub", "dtot","ltot",
              "layer1","layer2","layer3","layer4","layer5","layer6","disk1","disk2","disk3","disk4","disk5"]

  branches = ['trk_fake','trk_pt','trk_z0','trk_chi2rphi','trk_chi2rz','trk_phi','trk_eta','trk_chi2','trk_bendchi2','trk_nstub','trk_dhits','trk_lhits',
              'trk_matchtp_pt','trk_matchtp_z0','trk_matchtp_phi','trk_matchtp_eta','trk_matchtp_dxy','trk_matchtp_pdgid','trk_hitpattern',]
  events = [{}] * (num[1]-num[0])

  long_to_short = {'trk_fake':'trk_fake','trk_pt':'trk_pt','trk_z0':'trk_z0','trk_chi2rphi':'trk_chi2rphi',
                   'trk_chi2rz':'trk_chi2rz','trk_phi':'trk_phi','trk_eta':'trk_eta','trk_chi2':'trk_chi2',
                   'trk_bendchi2':'trk_bendchi2','trk_nstub':'trk_nstub','trk_dhits':'trk_dhits',
                   'trk_lhits':'trk_lhits','trk_matchtp_pt':'trk_matchtp_pt','trk_matchtp_z0':'trk_matchtp_z0',
                   'trk_matchtp_phi':'trk_matchtp_phi','trk_matchtp_eta':'trk_matchtp_eta',
                   'trk_matchtp_dxy':'trk_matchtp_dxy','trk_matchtp_pdgid':'trk_matchtp_pdgid','trk_hitpattern':'trk_hitpattern'}


  # Read the relevant branches into a list of events
  events = {}
  for branch in branches:
    events[long_to_short[branch]] = []

  # for i in range(1, 89):
  data = uproot.open(filename)["L1TrackNtuple"]["eventTree"].arrays(branches)
  

  for branch in data:
    for i,event in enumerate(data[branch]):
      if i > num[0] & i <= num[1]:  
        events[long_to_short[branch.decode("utf-8")]].append(event)
    

  # Pivot from dict of lists of arrays to list of dicts of arrays
  x = []
  for i in range((num[1]-num[0])):
    y = {}
    for branch in branches:
      y[long_to_short[branch]] = events[long_to_short[branch]][i]
    temp = pd.DataFrame(transformData(y))


    

    infs = np.where(np.asanyarray(np.isnan(temp)))[0]
    temp.drop(infs,inplace=True)
    if bit: (bitdata(temp))

    x.append(temp)
  events = x

  # Add some fields used to weight tracks
  

  return events 


def load_transformed_data(name,num_entries=100):
    store = pd.HDFStore(name+'.h5') 
    dataframe = store['df']
    store.close()
    return dataframe[0:num_entries]


def resample_event(event):
  import random
  

  fake_index = []
  true_index = []

  for index, row in event.iterrows():
    if row["trk_fake"] == 0:
      fake_index.append(index)
    else:
      true_index.append(index)

  
  true_index = random.sample(true_index,len(fake_index))


  
  fake_index.extend(true_index)


  
  return(event[event.index.isin(fake_index)])


    