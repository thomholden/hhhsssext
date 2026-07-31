function ErrWarnings(errcode)

title = 'notification!';
switch errcode
    case 'g001'
        text = {'More than one point found for given constraint';...
            'Press ''n'' for next point'};
    case 'g002'
        text = {'Value Entered is not in';'correct format'};
    case 'g003'
        text = {'The selected Locus cannot'; ' be transformed'};
    case 'g004'
        text = {'No point can be located with';'given contraints'};
    case 'g005'
        text = {'r and x are not been defined';'at this point'};
    case 'g006'
        text = {'Entered changes cannot be applied'};
    case 'g007'
        text = {'There is no Locus to'; ' be transformed'};
    case 'g008'
        text = {'Locus you are trying to construct already exist';...
            'changes made will be reverted'};
    case 'g009'
        text = {'The path with selected way cannot be constructed'};
        
    case 'g020'
        text = {'The Marker text already taken';'try some other text'};
    case 'g021'
        text = {'The text field of marker is empty';'Enter a text'};
    case 'g022'
        text = {'A marker already exits almost at the current location';...
            'try removing that first'};
        
    case 'g100'
        text = {'Something went wrong !! :-(';...
            'Please make a note of error code if any'};
        
end

dialog_gg('title', title, 'text', text);

if isequal(errcode, 'g100')
    disp('Initiate_Emergency_Exit');
end