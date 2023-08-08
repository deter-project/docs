!!! important
    This page is deprecated. Please use our <a href="https://launch.mod.deterlab.net/">new platform</a> and accompanying documentation.

# Human User Emulation using DASH 

DASH (Deterlab Agents Simulating Humans) are intended to simulate human behavior in a variety of situations in Deterlab and other environments, where group decision-making is mediated by computers. For example, they have been used to model observed behavior in:

- Managing passwords on multiple accounts
- Launching a coordinated SQL injection attack
- Making inferences and decisions while controlling a power plant. 

In situations like these, human behavior might differ from the optimal, as may be defined by decision-theoretic measures or accepted best practice, and these differences impact the behavior of systems under test. This may happen because the typical user of a system has an incorrect or incomplete model of the system’s behavior or of its security, or because humans inevitably make mistakes, particularly when their attention is taken with other tasks.

DASH agents model this behavior using a dual-process cognitive architecture. 

- The **rational** behavior module contains sub-modules for reactive planning and for projection using mental models. 
- The **instinctive** behavior module models instinctive reactions and other reasoning that humans are typically not aware of

The combination of these two modules can account for effects of cognitive load, time pressure, or fatigue on human performance, which have been documented in many different domains. The combination can also duplicate some well-known human biases in reasoning, such as confirmation bias. The DASH platform includes support for teams of agents that communicate with each other and a GUI to control agent parameters and view the state of both modules as the agent executes.

It can be time consuming to program agent behaviors, and a typical cyber security test scenario may include a number of relatively standard agents, with some alterations to a few key players. Therefore DASH provides a library of agents that can be used in a range of situations and extended as required, covering end user behavior as well as attackers and defenders, though the latter are currently more limited.

Please see DASH documentation [here](https://github.com/isi-usc-edu/dash/blob/master/docs/DASH_guide.docx) and download DASH from [https://github.com/isi-usc-edu/dash](https://github.com/isi-usc-edu/dash)

DASH can simulate traffic stemming from user actions, or it can *emulate* it by sending real traffic in a DeterLab experiment. Documentation showing how to use DASH in emulation is [here](https://docs.google.com/document/d/1uJaL1aQa5BtSIYQHE2fnyXZHENM-WE4_/edit?usp=sharing&ouid=106458123212792183536&rtpof=true&sd=true).

For comments or questions about DASH and to obtain a copy for research purposes, please contact Jim Blythe at [blythe@isi.edu](mailto:blythe@isi.edu).
