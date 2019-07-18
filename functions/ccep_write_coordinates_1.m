function [t, t_empty, elecmatrix] = ccep_write_coordinates_1(dataRootPath, subj, ses)

%   This function part of writing the electrodes to the electrodes.tsv file
%   It load the electrodes.tsv file and a GIU to select the electrodes positions matrix. 
%   It prints the table and elecmatrix on purpose, because these have to be
%   set manually in the next step.

%   By Dora Hermes, Jaap van der Aar, Giulio Castegnaro 2019 (full script)

%   Modified by Jaap van der Aar, adjusted to current pipeline/structure 05-2019

% select the .mat file that contains the 'elecmatrix' (because it sometimes has 
% different names, and not in BIDS, this is best done by GUI)
filename_path = fullfile(dataRootPath,['sub-' subj],['ses-' ses],'ieeg',...
    (uigetfile('*.mat','Select *.mat file',...
    [fullfile(dataRootPath,['sub-' subj],['ses-' ses],'ieeg')])));
load(filename_path);

% load empty electrodes.tsv to add the elecmatrix to
% print both and their sizes to see where to implement the elecmatrix
t = readtable(fullfile(dataRootPath,['sub-' subj],['ses-' ses],'ieeg',...
    ['sub-' subj '_ses-' ses '_electrodes.tsv']),...
    'FileType','text','Delimiter','\t','TreatAsEmpty',{'N/A','n/a'})
elecmatrix

whos t
whos elecmatrix;

% create new variable for saving, because t will be overwritten
t_empty = t;



