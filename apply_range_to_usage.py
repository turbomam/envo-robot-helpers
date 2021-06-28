import pandas as pd

envo_ids = pd.read_csv("get_envo_ids.tsv", sep="\t")

nmdc_envo_id_range = pd.read_csv("nmdc_envo_id_range.tsv", sep="\t")

# declared_min = nmdc_envo_id_range['?min']
# declared_min = declared_min.squeeze()

declared_max = nmdc_envo_id_range['?max']
declared_max = declared_max.squeeze()

flag = envo_ids["?suffix"] <= declared_max

used = envo_ids[flag]

used_max = used.max().squeeze()

print(used_max)