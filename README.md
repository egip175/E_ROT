# E_ROT
A software to design and run visuo-motor reaching tasks, programmed in Matlab.

Each programmed task has its own function and GUI, plus a GUI to run experiments that can combine different blocks and tasks. 
Each task will have an output, saved automatically in a folder relative to the Subject and the Block that has been run.

This program is meant to be used with a NETStation to record EEG signals. The EEG recording starts automatically at the 
beginning of a new block and stops at the end of the block, but can also be started and stopped at the experimenter’s 
discretion directly from the GUI. Each function is programmed to automatically send an event on target activation.
The program is intended to run on a Mac and cannot run on anything else with the current settings without some modifications, 
but it would be possible to adapt it fairly easily.

See E_ROT_Manual for a more in depth explanation.
