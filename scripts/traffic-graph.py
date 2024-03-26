# I have been digging around the outputs of  the commands
# weka stats --show-internal --interval 60 --stat PORT_TX_BYTES --per-node --param networkPortId:* > stats-PORT_TX_BYTES
# weka stats --show-internal --interval 60 --stat PORT_RX_BYTES --per-node --param networkPortId:* > stats-PORT_RX_BYTES

# I'd like some feedback, esp to know if my Pandas methodology is sane. I am using Jupyter notebook
# Is that useful or am I overcomplicating things here
#
# pip3 install pandas
# dnf -y install jpeg-devel
# pip3 install matplotlib

import pandas as pd

data_tx = pd.read_csv('stats-PORT_TX_BYTES', sep='[ ]{2,}', engine='python')
data_rx = pd.read_csv('stats-PORT_RX_BYTES', sep='[ ]{2,}', engine='python')

#cleanup the values
data_rx['VALUE'] = data_rx['VALUE'].str.replace(' Bytes/Sec| B/s| KiB/s', '')
data_rx['VALUE'] = data_rx['VALUE'].astype(float)
#display the result
data_rx

### Next Cell
# this one is the same as RX in the previous Cell
data_tx['VALUE'] = data_tx['VALUE'].str.replace(' Bytes/Sec| B/s| KiB/s', '')
data_tx['VALUE'] = data_tx['VALUE'].astype(float)
data_tx

### Next Cell
# To display the 3 highest results
data_tx.nlargest(3, "VALUE")

### Next Cell
data_rx.nlargest(3, "VALUE")

### Next Cell
# Bar Graphics to display the outliers I will focus on tx here
tx_pivoted = pd.pivot_table(data_tx, values= 'VALUE', index=['NODE'], columns= 'STAT').reset_index()
tx_graph = tx_pivoted.plot.bar(figsize=(120,60)).get_figure()

# Warning: This one is long to execute sometimes
# To save the graph as png
tx_graph.savefig('tx_plot.png')

