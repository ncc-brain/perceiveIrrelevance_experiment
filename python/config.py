import matplotlib.pyplot as plt

source_root = r'P:\2023-0383-PerceiveIrrelevance\03data\perceivedIrrelevance'
bids_root = r'C:\Users\alexander.lepauvre\Documents\GitHub\perceiveIrrelevance_experiment\bids'

colors = {
    'face': [(255-28)/255,(159-28)/255,(28-28)/255],
    'object': [(58-28)/255,(183-28)/255,(149-28)/255],
    'cmap': 'RdYlBu_r'
}


fig_size = [15, 20]
SMALL_SIZE = 22
MEDIUM_SIZE = 24
BIGGER_SIZE = 26
gaussian_sig = 4

plt.rc('font', size=SMALL_SIZE)  # controls default text sizes
plt.rc('axes', titlesize=SMALL_SIZE)  # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)  # fontsize of the x and y labels
plt.rc('xtick', labelsize=SMALL_SIZE)  # fontsize of the tick labels
plt.rc('ytick', labelsize=SMALL_SIZE)  # fontsize of the tick labels
plt.rc('legend', fontsize=SMALL_SIZE)  # legend fontsize
plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the fi
