---
title: Perceived Irrelevance
date: 2024-11-19
authors:
    - name: 'Alex Lepauvre'
      affiliations:
        - id: 'MPIAE'
          name: Max Planck Institute for empirical aesthetics
          email: alex.lepauvre@ae.mpg.de
    - name: 'Ece Ziya'
      affiliations:
        - id: MPIAE
    - name: 'Lucia Melloni'
      affiliations:
        - id: MPIAE
abstract: |
    Understanding how specific features of consciously experienced stimuli are represented in the brain is key to consciousness research. Recent studies suggest that the prefrontal cortex (PFC) encodes categorical information (e.g., object identity) but not features like orientation and duration, challenging theories like the Global Neuronal Workspace Theory (GNWT), which posits that the PFC integrates all aspects of conscious experience. Using a surprise memory paradigm, we tested whether participants consciously experience features undetectable in the PFC. Participants viewed visual stimuli varying in orientation and duration and were unexpectedly probed for these features. Our results show that participants remembered orientation and duration for faces but not objects, suggesting that conscious experience of these features depends on stimulus category. Faces were better remembered, likely due to holistic processing or salience. These findings challenge GNWT, highlight the role of attention and stimulus category in conscious perception, and provide new insights into the neural mechanisms of consciousness.
exports:
  - format: pdf
---

# Introduction
Understanding how specific features of consciously experienced stimuli are represented in the brain is fundamental to consciousness research. Previous studies have investigated which attributes of consciously perceived stimuli—such as category, orientation, and duration—are encoded in different brain regions (Consortium et al., 2023). One significant finding from these studies was that the prefrontal cortex (PFC) represents only category-specific information (e.g., distinguishing between different types of objects), while failing to represent other features like orientation and duration of visual stimuli (Consortium et al., 2023). This result poses a challenge to certain theories of consciousness, such as the Global Neuronal Workspace Theory (GNWT), which posits that the PFC plays a critical role in conscious experience by integrating all consciously perceived features ([](doi:10.1016/S0010-0277(00)00123-2), [](doi:10.1016/j.neuron.2011.03.018), [](doi:10.1016/j.tics.2006.03.007), [](doi:10.1016/j.neuron.2020.01.026)).
If the PFC truly underpins conscious experience, it would be expected to encode not just categorical information but also other consciously experienced features, like orientation and duration. Therefore, the lack of such representation in the PFC brings up two key possibilities:
1. Only categorical features are consciously experienced, meaning participants may be unaware of orientation and duration details.
2. If participants are, in fact, consciously aware of orientation and duration, the PFC’s lack of representation of these features questions theories (e.g., GNWT) that assign this region a primary role in supporting conscious experience.

In this study, we aimed to explore these possibilities further by investigating whether participants consciously experience features that were previously undetectable in the PFC. We designed a surprise memory paradigm to test participants’ awareness of orientation and duration of visual stimuli. In this experiment, participants performed a target detection task across a series of 43 trials, where they viewed visual stimuli presented with varying orientations and durations. This task setup matched that of prior studies in which the PFC failed to represent these non-categorical features. However, after the initial task trials, participants were unexpectedly presented with memory probes asking them to recall the orientation and duration of the stimuli.

By employing this design, we ensured that participants’ attention to orientation and duration was comparable to that in previous studies. The surprise memory probe allowed us to assess whether, despite the lack of decodable representation in the PFC, participants consciously experienced these features. This study thus provides a critical test of the GNWT and similar theories, helping clarify the role of the PFC in conscious perception.

# Methods
## Participants
A total of 72 participants were recruited for the surprise memory probe experiment (N Females=30, aged 27.24 ± 4.32). Twenty-four participants (N Females=10, aged 26.43 ± 2.54) were recruited through the Max Planck Institute for Empirical Aesthetics, Frankfurt, and participated in the lab. Data from 2 lab participants were replaced due to low performance and technical issues. The remaining 48 participants were recruited through the Prolific platform and completed the experiment online. Nine online participants were replaced due to technical issues or low performance. For the final analysis, data from 48 participants were used (N Females=20, aged 27.62 ± 4.93). Compensation was €7 per half hour for lab participants and £8 per hour for online participants who completed the experiment. All participants were required to be English speakers, aged 18–35, with good or corrected vision. Both experiments were conducted using standard procedures in the Max Planck Institute for Empirical Aesthetics, with the general approval of the Ethics Council of the Max Planck Society for Research Projects (2017). All participants gave informed consent before participation, including agreement to the online publication of anonymized data.

Exclusion criteria were based on participants’ performance in a preliminary target detection task (less than 80% hits and more than 20% false alarms), and data from those not meeting these criteria were replaced.

## Stimulus and apparatus

For the experiment, the same face and object stimuli used in the COGITATE study [](doi:10.1101/2023.06.23.546249) were utilized, consisting of 20 unique faces and 20 unique objects. The face stimuli were generated with FaceGen Modeler 3.1, varying in facial features, gender, and ethnicity, while the object stimuli were selected from the Object Databank, with views from the center, left, and right angles. An additional set of 20 faces and 20 objects was used for practice trials to prevent repetition of main stimuli. The face stimuli for practice were pre-generated, while the 20 object stimuli were newly created from Object Databank selections. All stimuli were equated in size, grayscaled and luminance equated using custom matlab code (The MathWorks Inc., 2023) and the SHINE toolbox [](doi:10.3758/BRM.42.3.671).

For the lab-based experiment, participants were seated 68 cm from the screen, and their eye-tracking data was collected. Online participants used their personal computers, calibrated for screen distance using a virtual chinrest and an online eye-tracking tool with a 10% calibration error threshold. Both lab and online participants completed practice trials and a calibration session prior to the main experiment.

## Experimental design and procedure

The experiment comprised one practice block and one main block, which included three trial sections: pre-surprise, surprise, and post-surprise trials (see [](#Figure1)) . In pre-surprise trials, participants performed a target detection task. Two target stimuli (faces or objects) were presented before the trials, and participants were instructed to detect these by pressing the spacebar during a 2-second window if either target appeared. Trials varied in stimulus orientation (center, left, right) and duration (500 ms or 1500 ms), with each trial including a fixation cross and a jittered display (0.2–2 seconds). In the pre-surprise trials, trials presented stimuli that belong to the same stimulus category as targets, defined as target-congruent (abbreviated as c in the rest of the paper) trials, and stimuli that belong to a different category than targets, defined as target-incongruent (abbreviated as ic) trials. The main block presented 42 pre-surprise trials (6 target trials, 18 c, and 18 ic) and trial order was pseudorandomized to prevent consecutive repetitions of the same trial condition.

Following the pre-surprise trials, a target stimulus was presented, followed by two memory probes asking participants to report two task-irrelevant features of the previous stimulus: orientation and duration of the stimulus, along with a confidence rating. A mind-wandering probe followed to assess focus. In post-surprise trials, stimuli were presented with memory probes to assess awareness of task-irrelevant features (orientation and duration). Participants’ responses were counterbalanced for target congruency across trials.

At the end of the experiment, demographic information was collected, and participants completed an exit questionnaire that gathered feedback on their experience with the surprise memory probes. The lab experiment took approximately 30–45 minutes, while the online version took around 23.5 minutes on average.

:::{figure} ./paper/figures/ExperimentalDesign.png
:label: Figure1
Experimental design
:::

# Results

## Surprise memory probe

In this experiment, we examined if task-irrelevant features of stimuli (like orientation and duration) are consciously experienced. After participants performed a target detection task, we unexpectedly asked them about these features. If they consciously experienced them, we expected memory performance above chance (50%), which we tested using a binomial test. We also anticipated performances differences between feature types (orientation and duration) and stimulus categories (faces vs. objects), so we analyzed them separately. To investigate potential categorical effects (i.e. differences between faces and objects), we compared memory performance between categories using a Fisher exact test.

As we can see in [](#Figure2), participants remember both the orientation and duration of face stimuli above chance in the combined data set (see Figure %s for statistics). For object stimuli however, participants were not able to remember either features above chance. The difference in memory performance between faces and objects was only significant for the orientation feature. Notably, while the difference in memory performance for the duration feature between faces and objects was not significant, the same trend was observed across both the in lab and online study, suggesting that the lack of effect is due to the smaller effect size that fails to be detected in our sample (see Figure %s for statistics)

:::{figure} #Figure2
:name: Figure 2
Surprise memory probe performance
:::

:::{figure} #Table1
:name: Table 1
Results of the binomial test comparing memory performance against chance
:::

:::{figure} #Table2
:name: Table 2
Results of the Fisher exact test comparing memory performance between faces and objects
:::

## Order effect

In our task, in order to avoid order effects, we counter-balanced which of the two features is asked first across participants. However, it is likely that task irrelevant features decay from memory rather fast, in which case the likelihood of a feature being remembered depends on whether the probe appeared first or second. To investigate this possibility, we compared the memory performance of each feature for each stimulus category separately depending on whether the probe occurred first or not [](#Figure3).

:::{figure} #Figure3
:name: Figure 3
Order effect
:::

:::{figure} #Table3
:name: Table 3
Results of the Fisher exact test comparing memory performance between subjects where a given attribute was probed first vs. second
:::

## Surprise vs. post-surprise memory performances

Participants did not remember orientation or duration perfectly for task-irrelevant features, except for faces. To assess whether poor memory in surprise trials was due to the difficulty of memorizing those features or simply their irrelevance, we compare memory performance in surprise vs. post-surprise trials, where these features became relevant.

In post-surprise trials, we counterbalanced stimulus categories so that half the participants saw a stimulus of the same category as in the surprise trial first, and the other half saw a different category. Accordingly, only half the participants saw a stimulus of the same category in the surprise and post-surprise category. As we are most interested in the memory performance separately for faces and objects, we need to compare the memory performance between the surprise and post-surprise trials of the same category. Based on our design, this can be achieved in two ways:
1. Compare face surprise trials with all face first post-surprise trials (and similarly for objects). In this case, half of the subjects that were shown a face in the post-surprise trial were not shown a a face in the surprise trial. To perform this comparison, we use a Fisher exact test, because for half of the subjects, the comparison is between subjects.
2. Select participants with congruent first post-surprise trials: Only participants who saw the same category as in the surprise trial are included. To perform this comparison, we use a McNemar test, as the measures are repeated within subject.

Both approaches will be performed to provide a comprehensive analysis.

## Comparing surprise and first control across subjects
In our design, participants were presented with either a face or an object in the surprise trial. Half of the participants who saw a face in the surprise trial saw a face in the 1st post-surprise trial (congruent) while the rest saw and object and reciprocally for the participants who saw an object in the surprise trial. Below, we compare memory performances between the surprise trial and the first post-surprise test of the same category. When comparing the memory performance of face orientation, we compare the results of all subjects who were presented with a face in the surprise trial, against the data of all the subjects who saw a face in the first post-surprise trial. Half of the latter saw a face in the surprise trial, while the rest saw an object.

:::{figure} #Figure4
:name: Figure 4
Comparison of memory performance in the surprise trial against the first control, combining data of participants who were presented with different stimuli in surprise and 1st control trials
:::

:::{figure} #Table4
:name: Table 4
Results of the Fisher exact test comparing memory performance between the surprise and first control trials
:::

Interestingly, there is no clear pattern of memory performances increase in the first post-surprise trial [](#Figure4). Notably, there seems to be a sharp decrease in performances for faces orientation that appears significant when comparing all face surprise and post-surprise trials. However, this decrease seems to be mainly driven by the in lab experiment. It is possible that in the lab, verbal instructions to the participants over-emphasized the surprise trial by mentioning to participants that an additional question will be asked at the end of the experiment. Once participants experienced this surprising question, they may not have expected additional trials to follow and been surprise of the occurrence of the first post-surprise trial. This may account for the unexpected decrease in memory performances.

## Comparing surprise and first control within subjects

Alternatively, this may be due to poorer performance in the first post-surprise trials from the half of the subjects who first saw an object in the surprise trial. To investigate this possibility, we compared the memory performance between the surprise trial and the first control of the congruent subjects only, that is the subjects who saw a stimulus of the same category as the target in the first control.

:::{figure} #Figure5
:name: Figure 5
Comparing surprise against 1st control only when the surprise and first control were of a congruent category
:::

:::{figure} #Table5
:name: Table 5
Results of the McNemar exact test comparing memory performance between the surprise and first control trials
:::

None of the comparison was observed to be significant [](#Figure5). It must however be noted hat the same trend of poorer performance in the first control remain present for faces orientation. Furthermore, this analysis can only be performed on half of the subjects compared to the previous one, it is therefore likely that the effect fails to reach statistical significance. This aligns with the interpretation that the participants may have been surprised by the first control trial, as they were not expecting to be surprised twice.

## Improvement of memory performances in post-surprise trials

We would expect that after being presented with the first post-surprise trials, participants should have been less surprised by the occurrence of the following post-surprise trials. We would therefore expect to see an increase in memory performance in subsequent surprise trials. To test this, we compared the memory performance for the subsequent post-surprise trials.

:::{figure} #Figure6
:name: Figure 6
Change in memory performance as a function of probe number
:::

Interestingly, it would seem that for faces, memory performances for both orientation and duration are already maxed out in the surprise trial, as we do not see any increasing trend in subsequent post-surprise trials [](#Figure6). In the case of objects however, we do see a clear increasing trend, indicating that memory performance are improved by making the feature task relevant. This result pattern fits nicely with the interpretation that faces are processed in a more holistic fashion, such that most task irrelevant features are encoded in memory.

# Discussion

Our findings reveal several important insights into the reportability of single features of consciously experienced stimuli, when these features themselves are not relevant to the task. One of the most striking results is the difference in memory performance between faces and objects, with faces features being remembered significantly better than objects for both orientation and duration. This suggests that faces and objects are processed differently, likely due to inherent differences in how these stimuli are attended to and encoded.

One possible interpretation is that faces are processed more holistically, meaning all features, even those irrelevant to the task, tend to be encoded together. Another interpretation could be that the inherent salience of faces draws more attention ([](doi:10.1177/0956797609359508), [](doi:10.1016/j.neuroimage.2010.10.075), [](doi:10.1523/JNEUROSCI.4977-03.2004), [](doi:10.1007/s00426-014-0599-8), [](doi:10.1016/s0896-6273(01)00328-2)), leading to more robust encoding of all features. This view is supported by the fact that we did not observe a substantial increase in memory performance for faces in post-surprise trials when these features became task-relevant, implying that participants may have already been attending to all aspects of a face regardless of task demands. This speaks to an object-based attention mechanism, where attending to a single aspect of an object (like identity) may lead to automatic encoding of other features ([](doi:10.1038/nn.3656), [](doi:10.3758/s13414-012-0322-z), [](doi:10.3758/s13414-022-02473-8), [](doi:KAHNEMAN), [](doi:10.1146/annurev.ne.18.030195.001205)).

Another noteworthy finding is the difference in memory performance between orientation and duration for faces. Orientation, a spatial feature, appears to be better remembered than duration. This could be because spatial attention is typically directed to the location of the stimulus on the screen, which might help encode orientation more effectively. Duration, however, is temporal and relies on memory ([](doi:10.55782/ane-2004-1516), [](doi:10.3758/BF03209393)). Participants may not have fully attended to the entire duration once they recognized the target information. If they disengaged from the stimulus shortly after recognizing it, they might not have robustly encoded the offset, leading to poorer memory performance for duration.

Our study also addresses a timely question in consciousness research: Do participants consciously experience task-irrelevant features of consciously experienced stimuli? For faces, the answer is a clear yes, as participants remembered both orientation and duration above chance. This is less clear for objects, where memory performance did not reach above-chance levels. When participants fail to remember a feature, it’s uncertain whether they consciously experienced it but forgot, or never consciously experienced it at all ([](doi:10.3758/s13421-019-00923-7), [](doi:10.7717/peerj.4016), [](doi:10.1037/xhp0000133)). However, for faces, the evidence strongly suggests that participants did consciously experience these task-irrelevant features.

These findings have implications for theories of consciousness, particularly the Global Neuronal Workspace Theory (GNWT), which suggests that the prefrontal cortex (PFC) integrates all consciously experienced features ([](doi:10.1016/j.tics.2006.03.007), [](doi:10.1016/j.neuron.2011.03.018), [](doi:10.1016/S0010-0277(00)00123-2)). Recent studies showed that the PFC failed to encode orientation and duration ([](doi:10.1101/2023.06.23.546249)), challenging GNWT’s claim about the PFC’s role in conscious perception. Our results imply that participants did experience orientation and duration, at least for faces, suggesting that the PFC’s lack of encoding these features raises questions about GNWT’s framework.

It’s worth noting that this study focused on target stimuli, which were not analyzed in prior research like the COGITATE study. It’s possible that orientation might have been decodable from the PFC specifically for target stimuli, a question that future research could explore by testing memory for task-irrelevant features in various contexts. Overall, these findings underscore the importance of stimulus category and attentional dynamics in conscious perception, raising intriguing questions for the study of consciousness and the neural mechanisms underlying it.

