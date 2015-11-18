[wiki:UsingNodes < Using Your Nodes] | [wiki:linkdelays End Node Traffic Shaping and Multiplexed Links >]

LegoTG is a flexible framework for pulling together the appropriate software for the traffic generation process. The key insight of LegoTG is that the definition of "realism" in traffic generation is entirely dependent on the experiment/scenario. LegoTG itself does not determine what "realistic" traffic means for a particular experiment or scenario. Rather, the definition of realism must come from the LegoTG user.

LegoTG enables a modular and composable approach to the traffic generation process. LegoTG's Orchestrator handles tying together various modules which handle the different aspects of generation and allows a user to create a plug-and-play traffic generator. We are developing software to perform data extraction as well as working on a generator which will be generic enough to handle a variety of modeled dimensions.


In the LegoTG framework, each traffic generation functionality is realized through a separate piece of code, called a TGblock. The framework works like a child’s building block set: TGblocks combine in different ways to achieve customizable and composable traffic generation. This combination and customization is achieved through LegoTG’s Orchestrator, which sets up, configures, deploys, runs, synchronizes and stops TGblocks in distributed experiments. The entire specification of the traffic generation process for an experiment is in an experiment configuration file—called an ExFile, which is an input for the Orchestrator. The ExFile offers a convenient capture of all the details of an experiment’s background traffic set up, which promotes sharing and reproducibility of experiments. 

For more information and to download software, please see the [LegoTG](http://steel.isi.edu/Projects/legoTG/) project page.



[wiki:UsingNodes < Using Your Nodes] | [wiki:linkdelays End Node Traffic Shaping and Multiplexed Links >]
 