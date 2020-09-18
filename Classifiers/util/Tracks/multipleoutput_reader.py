import util_funcs
import codecs
import numpy as np
import bitstring as bs
import xgboost as xgb



import sys



GBDT_predictions = []
GBDT_valid = []

Target = []





inputfile = open('input.txt', 'r') 
inLines = inputfile .readlines() 
input_data = []
for i,line in enumerate(inLines):
    if i > 3: 
        frame = line.partition(":")[0]
        removed_frame = line.partition(":")[2]
        #val1 = removed_frame.split("v")[0]
        link1 = removed_frame.split(" ")[1]
        link2 = removed_frame.split(" ")[2]

        val1 = link1.partition("v")[0]
        val2 = link2.partition("v")[0]
        data1 = link1.partition("v")[2].rstrip()
        data2 = link2.partition("v")[2].rstrip()

 

        #print('\''+data1+'\'')
            #print('\''+data2+'\'')

        binary_input1 = bs.BitArray(hex=data1)
            #print(binary_input1.bin)
            #print(binary_input1[52:64])

        binary_input2 = bs.BitArray(hex=data2)
            #print(binary_input2.bin)

        BigInvR = (binary_input1[49:64].int)/(2**7)
       #phi = (binary_input1[37:49].int)
        TanL = (binary_input1[21:37].int)

        z0 =   (binary_input1[9:21].int)/(2**7)

        #do = (binary_input2[51:64].int)
        bendchi = (binary_input2[48:51].uint)/(2**-1)
        hitmask = (binary_input2[41:48].uint)
        chi2rz = (binary_input2[37:41].uint)/(2**7)
        chi2rphi = (binary_input2[33:37].uint)/(2**7)
        
            
        trk_fake = int(binary_input2[32])
        
        chi2 = chi2rz + chi2rphi

        [layer1,layer2,layer3,layer4,
         layer5,layer6,disk1,disk2,disk3,
         disk4,disk5,pred_dtot,
         pred_ltot,pred_nstub] = util_funcs.single_predhitpattern(hitmask,TanL)

        TanL = TanL/(2**7)
      
        in_array = np.array([chi2,bendchi,chi2rphi,chi2rz,
                                pred_nstub,layer1,layer2,layer3,layer4,
                                layer5,layer6,disk1,disk2,disk3,
                                disk4,disk5,BigInvR,TanL,z0,pred_dtot,pred_ltot])

        if i == int(sys.argv[1]):
            print(in_array[16:21])
        
        in_array = np.expand_dims(in_array,axis=0)

        
           


file1 = open('output.txt', 'r') 
Lines = file1.readlines() 


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

        
        
        a = bs.BitArray(hex=data1)


        b1 = ((a[52:64].int))/2**7
        b2 = ((a[40:52].int))/2**7
        b3 = ((a[28:40].int))/2**7
        b4 = ((a[16:28].int))/2**7
        b5 = ((a[4:16].int))/2**7

        if i == int(sys.argv[1])+9:
            print(b5,'|',b4,'|',b3,'|',b2,'|',b1,'|')

        
            


 