function [taxanames,charnames,datamatrix]=dodatablock(fid,ntax);

% [taxanames,charnames,datamatrix]=dodatablock(fid)
% returns the cell arrays taxanames and charnames 
% and the numeric datamatrix with length(taxanames) rows.
%
% Note that it is assumed that the matrix in the file
% identified by fid is numeric (except for missing or gap data),that
% each character is represented by a single symbol and that character 
% sequences contain no whitespace (except for line breaks in interleaved data).
%
% It is also necessary to explicitly state values for NTAX and NCHAR in file

global MIX GAP

%set default values for reading in data
missing='?';
gap='-';
interleave=0;
taxanames={};
charnames={};
datamatrix=[];
nchar=-1;
if ntax == 0
    ntax=-1;
end
% want DIMENSIONS and FORMAT commands as well as the MATRIX
token=upper(gettoken(fid));
while ~feof(fid) & ~strcmp(token,'END') & ~strcmp(token,'ENDBLOCK')
    switch token
        
    case 'DIMENSIONS'
        while ~feof(fid) & token~=';' 
            token=upper(gettoken(fid));
            switch token
                % if the the token is a recognised command pay attention
                % otherwise just keep reading
            case 'NTAX'
                if gettoken(fid)~='='
                    disp('Error in reading DATA block. NTAX could not be read'); 
                else
                    ntax=str2num(gettoken(fid));
                end                    
            case 'NCHAR'
                if gettoken(fid)~='='
                    disp('Error in reading DATA block. NCHAR could not be read');
                else
                    nchar=str2num(gettoken(fid));
                end                    
            end
        end
        if nchar<0 
            disp('Error in reading DATA block.  NCHAR was not found.');
            keyboard;
        elseif ntax<0
            disp('Error in reading DATA block.  NTAX was not found.');
            keyboard;
        else
            datamatrix=zeros(ntax,nchar);
            strdatamat=char(datamatrix);
        end
        
    case 'FORMAT'
        while ~feof(fid) & token~=';' 
            token=upper(gettoken(fid));
            switch token
                % if the the token is a recognised command pay attention
                % otherwise just keep reading
            case 'MISSING'
                if gettoken(fid) ~= '='
                    disp('Error in reading DATA block. MISSING character undefined. Will use ''?''.');
                else
                    missing=gettoken(fid);
                end                    
            case 'GAP'
                if gettoken(fid) ~= '='
                    disp('Error in reading DATA block. GAP character undefined. Will use ''-''');
                else
                    gap=gettoken(fid);
                end                    
            case 'INTERLEAVE'
                interleave=1;
            end
        end
        
    case 'CHARLABELS'
        disp('Reading CHARLABELS')
        if nchar<0 
            disp('Error in reading CHARLABELS:  the dimension NCHAR needs to be defined before the char names can be read.');
        elseif nchar==0
            charnames={};
        else
            charnames{nchar}=[];
            token = gettoken(fid);
            namesread=0;
            while ~feof(fid) & token ~= ';'
                namesread=namesread+1;
                if namesread > nchar
                    disp('Error in DATA block - there are more than NCHAR cognate names')
                else
                    charnames{namesread}=token;
                end
                token = gettoken(fid);
            end
        end
    case 'CHARSTATELABELS'
        disp('Reading CHARSTATELABELS')
        if nchar<0 
            disp('Error in reading CHARLABELS:  the dimension NCHAR needs to be defined before the char names can be read.');
        elseif nchar==0
            charnames={};
            charnums=zeros(1,0);
        else
            charnames{nchar}=[];
            charnums = zeros(1,nchar);%charnames;
            token = gettoken(fid);
            namesread=0;
            while ~feof(fid) & token ~= ';'
                namesread=namesread+1;
                if namesread > nchar
                    disp('Error in DATA block - there are more than NCHAR cognate names')
                else
                    charnums(namesread) = str2double(token);
                    charnames{namesread}=gettoken(fid);
                    while ~feof(fid)  & token ~= ',' & namesread < nchar
                        token = gettoken(fid);
                    end
                end
                token = gettoken(fid);
            end
            if charnums ~= 1:nchar
                % need to sort the character names
                [charnums i] = sort(charnums);
                charnames = charnames(i);
            end
            if length(charnames) ~= nchar
                disp(sprintf('Error in CHARSTATELABELS command: expected NCHAR = %1.0f character names, found %1.0f',nchar,length(charnames)));
            end
        end
    case 'MATRIX'
        % interleaved matrices have format:
        % name sequence newline name sequence newline etc
        % so read in name and sequence  
        disp('Reading MATRIX')
        if ntax <=0 | nchar < 0 
            disp('Error in reading MATRIX:  the dimensions NTAX and NCHAR need to be defined before the matrix can be read')
        %elseif nchar==0
        %    disp('Empty data matrix - zero cognates')
        %    datamatrix=zeros(ntax,0); 
        %    taxanames=strrep(num2cell(num2str([1:ntax]'),2),' ','');   
        %    while ~feof(fid) & token ~= ';'        
        %        token=gettoken(fid);    
        %    end
        else
            charread=zeros(ntax,1);
            token=gettoken(fid);
            firstround=1;
            currtax=0;
            taxanames{ntax}=[];
            celldata=cell(ntax,1);
            [celldata{:}]=deal(blanks(nchar));
            while ~feof(fid) & token ~= ';'
                if currtax==ntax
                    currtax=1;
                    firstround=0;
                else 
                    currtax=currtax+1; 
                end
                
                if firstround
                    taxanames{currtax}=token;
                end
              
                if nchar>0
                    % at data segment - read in including missing and gap characters
                    dataline = fscanf(fid,'%s',1);%gettoken(fid,[missing gap]);
                    % check that we have not read too many characters
                    if charread(currtax)+length(dataline)>nchar
                        disp(['Too many cognates in matrix for language ' taxanames{currtax}])
                        keyboard;
                    end
                    celldata{currtax}((charread(currtax)+1):(charread(currtax)+length(dataline)))=dataline;
                    charread(currtax)=charread(currtax)+length(dataline);
                end

                if currtax ~=ntax
                    token = fscanf(fid,'%s',1);%gettoken(fid);
                else % have to take care that we skip and comments
                    token = gettoken(fid);
                end
            end
            if nchar>0
                % replace any missing data
                celldata = strrep(celldata,missing,sprintf('%1.0f',MIX));
                celldata = strrep(celldata,gap,sprintf('%1.0f',GAP));
                % convert to numeric array
                paddedmat = char(zeros(ntax,2*nchar-1)+32);
                paddedmat(:,1:2:(2*nchar-1)) = char(celldata);
                   %% DW 19/7/2007
                if nchar < 10000
                datamatrix=str2num(paddedmat);
                else
                    datamatrix = zeros(ntax,nchar);
                   for i = 1:ntax
                      datamatrix(i,:) =  str2num(paddedmat(i,:));
                   end
                end
                   %% DW 19/7/2007 END
            else
                datamatrix=zeros(ntax,0);
            end
        end
    otherwise
        skipcommand(fid);
    end       
    token=upper(gettoken(fid));
end

