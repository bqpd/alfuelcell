function importtrace(fileToRead_csv)
%IMPORTTRACE(FILETOREAD_CSV)
%  Imports data from an oscilloscope-made trace file.

DELIMITER = ',';
HEADERLINES = 2;

data = importdata(fileToRead_csv, DELIMITER, HEADERLINES);

% Create new variables in the current workspace from those fields.
for i = 1:size(data.colheaders, 2)
    assignin('caller', genvarname(data.colheaders{i}), data.data(:,i));
end
end

