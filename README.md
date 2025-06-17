# DSENL
Dual-Semantic Enhancement Cross-Modal Hashing with Noisy Labels
# Datasets
Download from the following link:https://pan.baidu.com/s/1rCaVFSTPaCUd67ifRvJLag with code:4p76
# Run Demo
Please download the datasets and put it into /datasets
Run main_DSENL.m

### 1. Mathematical derivation of noisy labels settings

### 1. Mathematical derivation of noisy labels settings

Specifically, assuming a rate of noise (RON) of 0.2, define:

$$
\mathcal{I} = \{(i,j) \mid y_i = 0,\ \forall i \in [1, n],\ j \in [1, C] \}
$$

$$
\Omega = \{ S_{\text{subset}} \subseteq \mathcal{I} \mid |S_{\text{subset}}| = \lfloor 0.2n \rfloor \}
$$

Where:

- $\mathcal{I}$ denotes the set of index pairs where the label is 0.
- $\Omega$ is the set of all possible mislabeled subsets.
- $n$ is the number of samples.
- $C$ is the total number of classes.
- $k = \lfloor 0.2n \rfloor$ is the number of indices to be randomly chosen.
- $S_{\text{subset}} = \{(i_1, j_1), (i_2, j_2), \ldots, (i_k, j_k)\}$ is a subset from $\Omega$.

The mislabeled index set is defined as:

$$
D_1 = \{(i,j) \mid (i,j) \in S'\}
$$

Where $S'$ is a randomly selected subset drawn uniformly from $\Omega$, with the probability distribution satisfying:

$$
\mathbb{P}(S' = S) = \frac{1}{|\Omega|} = \frac{1}{\binom{nm}{k}}, \quad \forall S \in \Omega
$$

Where:

$$
\binom{nm}{k} = \frac{(nm)!}{k!(nm - k)!}
$$

denotes the binomial coefficient.

Similarly, define the missing label set as:

$$
\mathcal{J} = \{(i,j) \mid y_i = 1,\ \forall i \in [1, m],\ j \in [1, C] \}
$$

$$
\Theta = \{ M_{\text{subset}} \subseteq \mathcal{J} \mid |M_{\text{subset}}| = \lfloor 0.2m \rfloor \}
$$

$$
D_2 = \{(i,j) \mid (i,j) \in M'\}
$$

Where:

- $\mathcal{J}$ is the set of index pairs where the label is 1.
- $\Theta$ is the set of missing label subsets.
- $m$ is the number of samples.
- $M'$ is a randomly selected subset from $\Theta$.

Assuming the original label matrix is $Y$, the noisy label matrix $Y'$ is defined as:

$$
Y'_{i,j} = 
\begin{cases}
1 - Y_{i,j}, & \text{if } (i,j) \in D_1 \cap (i,j) \in D_2 \\
Y_{i,j}, & \text{otherwise}
\end{cases}
$$


### 2. Random Number Experiment

#### TABLE I: mAP Results on MIRFlickr-25K with Different Code Lengths and RON

| Task              | Method | 16 (RON=0.2) | 32          | 64          | 128         | 16 (RON=0.6) | 32          | 64          | 128         |
| ----------------- | ------ | ------------ | ----------- | ----------- | ----------- | ------------ | ----------- | ----------- | ----------- |
| $T \rightarrow I$ | DSENL  | 0.783±0.012  | 0.792±0.011 | 0.804±0.011 | 0.815±0.013 | 0.616±0.014  | 0.626±0.015 | 0.628±0.013 | 0.639±0.015 |
| $I \rightarrow T$ | DSENL  | 0.716±0.007  | 0.726±0.006 | 0.723±0.007 | 0.732±0.008 | 0.580±0.012  | 0.592±0.013 | 0.609±0.011 | 0.610±0.014 |



------

#### TABLE II: mAP Results on NUSWIDE with Different Code Lengths and RON

| Task              | Method | 16 (RON=0.2) | 32          | 64          | 128         | 16 (RON=0.6) | 32          | 64          | 128         |
| ----------------- | ------ | ------------ | ----------- | ----------- | ----------- | ------------ | ----------- | ----------- | ----------- |
| $T \rightarrow I$ | DSENL  | 0.697±0.006  | 0.710±0.007 | 0.722±0.007 | 0.734±0.008 | 0.406±0.008  | 0.414±0.010 | 0.424±0.009 | 0.435±0.011 |
| $I \rightarrow T$ | DSENL  | 0.608±0.005  | 0.618±0.004 | 0.623±0.005 | 0.632±0.006 | 0.383±0.007  | 0.392±0.008 | 0.404±0.005 | 0.413±0.007 |



------

#### TABLE III: mAP Results on IAPRTC-12 with Different Code Lengths and RON

| Task              | Method | 16 (RON=0.2) | 32          | 64          | 128         | 16 (RON=0.6) | 32          | 64          | 128         |
| ----------------- | ------ | ------------ | ----------- | ----------- | ----------- | ------------ | ----------- | ----------- | ----------- |
| $T \rightarrow I$ | DSENL  | 0.564±0.007  | 0.594±0.006 | 0.616±0.008 | 0.632±0.008 | 0.414±0.009  | 0.434±0.008 | 0.456±0.008 | 0.475±0.010 |
| $I \rightarrow T$ | DSENL  | 0.485±0.008  | 0.505±0.009 | 0.514±0.010 | 0.526±0.011 | 0.379±0.010  | 0.386±0.009 | 0.402±0.008 | 0.413±0.011 |



------

#### TABLE IV: mAP Results on MSCOCO with Different Code Lengths and RON

| Task              | Method | 16 (RON=0.2) | 32          | 64          | 128         | 16 (RON=0.6) | 32          | 64          | 128         |
| ----------------- | ------ | ------------ | ----------- | ----------- | ----------- | ------------ | ----------- | ----------- | ----------- |
| $T \rightarrow I$ | DSENL  | 0.653±0.008  | 0.675±0.006 | 0.695±0.009 | 0.713±0.010 | 0.504±0.011  | 0.501±0.009 | 0.516±0.010 | 0.527±0.009 |
| $I \rightarrow T$ | DSENL  | 0.555±0.007  | 0.550±0.008 | 0.555±0.010 | 0.556±0.007 | 0.470±0.009  | 0.473±0.008 | 0.484±0.009 | 0.483±0.007 |



### 3. Supplementary Noise Experiments

#### TABLE I(a): mAP Results on MIRFlickr-25K with Different Code Lengths

| Task    | Method   | 16-bit     | 32-bit     | 64-bit     | 128-bit    |
| ------- | -------- | ---------- | ---------- | ---------- | ---------- |
| **T→I** | FSH [61] | *0.6043*   | *0.6168*   | *0.6195*   | *0.6187*   |
|         | DSENL    | **0.6341** | **0.6355** | **0.6421** | **0.6592** |
| **I→T** | FSH [61] | **0.6115** | **0.6280** | *0.6303*   | *0.6304*   |
|         | DSENL    | *0.6090*   | *0.6267*   | **0.6376** | **0.6429** |



### **TABLE I(b)**: mAP Results on **NUSWIDE** with Different Code Lengths

| Task    | Method   | 16-bit     | 32-bit     | 64-bit     | 128-bit    |
| ------- | -------- | ---------- | ---------- | ---------- | ---------- |
| **T→I** | FSH [61] | *0.4904*   | *0.5007*   | *0.4981*   | *0.5089*   |
|         | DSENL    | **0.5026** | **0.5133** | **0.5313** | **0.5438** |
| **I→T** | FSH [61] | **0.5130** | **0.5132** | **0.5150** | **0.5279** |
|         | DSENL    | *0.4845*   | *0.4923*   | *0.5054*   | *0.5144*   |



### **TABLE I(c)**: mAP Results on **IAPRTC-12** with Different Code Lengths

| Task    | Method   | 16-bit     | 32-bit     | 64-bit     | 128-bit    |
| ------- | -------- | ---------- | ---------- | ---------- | ---------- |
| **T→I** | FSH [61] | *0.3875*   | *0.4001*   | *0.4057*   | *0.4100*   |
|         | DSENL    | **0.4723** | **0.5015** | **0.5174** | **0.5347** |
| **I→T** | FSH [61] | *0.3940*   | *0.4063*   | *0.4100*   | *0.4140*   |
|         | DSENL    | **0.3972** | **0.4108** | **0.4240** | **0.4364** |

