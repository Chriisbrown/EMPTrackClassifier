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

def transformData(dataframe):
    dataframe["InvR"] = pttoR(dataframe["trk_pt"])
    dataframe["BigInvR"] = 1000*dataframe["InvR"]
    dataframe["TanL"] = tanL(dataframe["trk_eta"])
    dataframe["LogChirphi"] = logChi(dataframe["trk_chi2rphi"])
    dataframe["LogChirz"] = logChi(dataframe["trk_chi2rz"])
    dataframe["LogChi"] = logChi(dataframe["trk_chi2"])
    dataframe["ModZ"] = np.abs(dataframe["trk_z0"])
    dataframe["dtot"] = sum_digits3(dataframe["trk_dhits"])
    dataframe["ltot"] = sum_digits3(dataframe["trk_lhits"])
    dataframe["trk_invpt"] = 1/dataframe["trk_pt"]
    dataframe["trk_matchtp_invpt"] = 1/dataframe["trk_matchtp_pt"]
    dataframe["LogBendChi"] = np.log(dataframe["trk_bendchi2"])
    dataframe["combined"] = np.sqrt( ((dataframe["LogChi"])/max(dataframe["LogChi"]))**2 + ((dataframe["LogBendChi"])/max(dataframe["LogBendChi"]))**2 )
    dataframe = nhotdisk(dataframe)
    dataframe = nhotlayer(dataframe)
    dataframe["trk_px"] = dataframe["trk_pt"]*np.cos(dataframe["trk_phi"])
    dataframe["trk_py"] = dataframe["trk_pt"]*np.sin(dataframe["trk_phi"])

    dataframe["trk_matchtp_px"] = dataframe["trk_matchtp_pt"]*np.cos(dataframe["trk_matchtp_phi"])
    dataframe["trk_matchtp_py"] = dataframe["trk_matchtp_pt"]*np.sin(dataframe["trk_matchtp_phi"])

    return dataframe

def bitdata(dataframe):
  dataframe["BigInvR"] = ((dataframe["BigInvR"]/max(abs(dataframe["BigInvR"])))*(2**3-1)).astype(int)
  dataframe["TanL"] = ((dataframe["TanL"]/max(abs(dataframe["TanL"])))*(2**3-1)).astype(int)
  dataframe["LogBendChi"] = ((dataframe["LogBendChi"]/max(abs(dataframe["LogBendChi"])))*(2**7-1)).astype(int)
  dataframe["LogChirphi"] = ((dataframe["LogChirphi"]/max(abs(dataframe["LogChirphi"])))*(2**7-1)).astype(int)
  dataframe["LogChirz"] = ((dataframe["LogChirz"]/max(abs(dataframe["LogChirz"])))*(2**7-1)).astype(int)
  dataframe["LogChi"] = ((dataframe["LogChi"]/max(abs(dataframe["LogChi"])))*(2**7-1)).astype(int)
  dataframe["ModZ"] = ((dataframe["ModZ"]/max(abs(dataframe["ModZ"])))*(2**3-1)).astype(int)


  print(max(dataframe["BigInvR"]))
  print(max(dataframe["TanL"]))
  print(max(dataframe["LogBendChi"]))
  print(max(dataframe["LogChirphi"]))
  print(max(dataframe["LogChirz"]))
  print(max(dataframe["LogChi"]))
  print(max(dataframe["ModZ"]))


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
  events = [{}] * num

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
      if i == num:
          break
      events[long_to_short[branch.decode("utf-8")]].append(event)
    

  # Pivot from dict of lists of arrays to list of dicts of arrays
  x = []
  for i in range(num):
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



    