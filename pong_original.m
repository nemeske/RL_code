function Pong

%--------------------------------------------------------------------------
%Pong
%Version 1.10
%Created by Stepen
%Created 10 July 2011
%Last modified 19 October 2011
%--------------------------------------------------------------------------
%Pong starts GUI game of ATARI's pong.
%--------------------------------------------------------------------------
%How to play pong:
%Player controls the left paddle by moving it up (by pressing w key) and
%down (by pressing down key) or by moving your mouse in order to prevent
%the ball from entering player's goal. To score and win, the ball must
%enter the opposition goal.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Reseting MATLAB environment
    close all
    clear all
%Declaring global variable
    ScreenSize=get(0,'ScreenSize');
    global ball ppaddle cpaddle
    goal2win=5;
    windowsize=[1024,560];
    fieldlength=200;
    fieldwidth=100;
    goalwidth=50;
    paddlespeed=1;
    paddlebouncevelratio=1.1;
    playerpaddlepos=[-0.4*fieldlength,0];
    playerpaddlespeed=0;
    playerpaddlexdat=[];
    playerpaddleydat=[];
    playerpaddlethickness=2.5;
    playerpaddlelength=20;
    compaddlepos=[0.4*fieldlength,0];
    compaddlexdat=[];
    compaddleydat=[];
    compaddlethickness=2.5;
    compaddlelength=20;
    ballradius=4;
    ballinitspeed=1;
    balldirection=(rand*2*pi())-pi();
    ballpos=[0,0];
    ballvel=[ballinitspeed*cos(balldirection),...
             ballinitspeed*sin(balldirection)];
    framedelay=0.01;
    centermousepos=[0.5*(ScreenSize(3)-windowsize(1))+...
                    0.1*windowsize(1)+...
                    0.08*windowsize(1),...
                    0.5*(ScreenSize(4)-windowsize(2))+...
                    0.15*windowsize(2)+...
                    0.4*windowsize(2)];
    currentmousepos=centermousepos;
    lastmousepos=centermousepos;
    playstat=0;
    pausestat=0;
    resetstat=0;
    winstat=0;
    playerscore=0;
    comscore=0;
%Generating GUI
    mainwindow=figure('Name','Pong',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-windowsize(1)),...
                                  0.5*(ScreenSize(4)-windowsize(2)),...
                                  windowsize(1),windowsize(2)],...
                      'KeyPressFcn',@pressfcn,...
                      'KeyReleaseFcn',@releasefcn);
    axes('Parent',mainwindow,...
         'Position',[0.1,0.15,0.8,0.8],...
         'XLimMode','manual',...
         'XLim',[-0.5*fieldlength 0.5*fieldlength],...
         'YLimMode','manual',...
         'YLim',[-0.5*fieldwidth 0.5*fieldwidth]);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String','Player',...
              'FontSize',10,...
              'BackGroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.025,0.6,0.05,0.025]);
    playerscorebox=uicontrol('Parent',mainwindow,...
                             'Style','text',...
                             'String','0',...
                             'FontSize',40,...
                             'BackGroundColor',[0.8 0.8 0.8],...
                             'Units','normalized',...
                             'Position',[0.025,0.5,0.05,0.1]);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String','COM',...
              'FontSize',10,...
              'BackGroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.925,0.6,0.05,0.025]);
    comscorebox=uicontrol('Parent',mainwindow,...
                          'Style','text',...
                          'String','0',...
                          'FontSize',40,...
                          'BackGroundColor',[0.8,0.8,0.8],...
                          'Units','normalized',...
                          'Position',[0.925,0.5,0.05,0.1]);
    highlightbox=uicontrol('Parent',mainwindow,...
                           'Style','text',...
                           'String','3',...
                           'FontSize',40,...
                           'BackgroundColor','g',...
                           'Visible','Off',...
                           'Units','normalized',...
                           'Position',[0.3,0.5,0.4,0.1]);
    uicontrol('Parent',mainwindow,...
                       'Style','text',...
                       'String','Ball Speed',...
                       'Visible','On',...
                       'BackGroundColor',[0.8,0.8,0.8],...
                       'Units','normalized',...
                       'Position',[0.475,0.15,0.05,0.025]);
    speedbox=uicontrol('Parent',mainwindow,...
                       'Style','text',...
                       'String','0',...
                       'Visible','On',...
                       'BackGroundColor',[0.8,0.8,0.8],...
                       'Units','normalized',...
                       'Position',[0.475,0.125,0.05,0.025]);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String','Game control',...
              'Visible','On',...
              'BackGroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.1,0.075,0.8,0.025]);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String',['w - move paddle up',...
                        '     s - move paddle down'],...
              'Visible','On',...
              'BackGroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.1,0.05,0.8,0.025]);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String',['z - pause game',...
                        '     x - restart game',...
                        '     c - quit and close game'],...
              'Visible','On',...
              'BackGroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.1,0.025,0.8,0.025]);
%Declaring LocalFunction
    %Start of Drawfield
    function DrawField
        %Setting plot parameter
        axis equal
        axis([-0.5*fieldlength,0.5*fieldlength,...
              -0.5*fieldwidth 0.5*fieldwidth])
        axis off
        hold on
        %Drawing field
        rectangle('Position',[-0.5*fieldlength,-0.5*fieldwidth,...
                              fieldlength,fieldwidth],...
                  'FaceColor','g',...
                  'LineStyle','none')
        %Drawing field line
        line([-0.5*fieldlength,-0.5*fieldlength,...
              0.5*fieldlength,0.5*fieldlength],...
             [0.5*goalwidth,0.5*fieldwidth,...
              0.5*fieldwidth,0.5*goalwidth],...
             'LineWidth',5,...
             'Color','w')
        line([-0.5*fieldlength,-0.5*fieldlength,...
              0.5*fieldlength,0.5*fieldlength],...
             [-0.5*goalwidth,-0.5*fieldwidth,...
              -0.5*fieldwidth,-0.5*goalwidth],...
             'LineWidth',5,'Color','w')
        line([0,0],[-0.5*fieldwidth,0.5*fieldwidth],...
             'LineWidth',2.5,'Color','w')
        rectangle('Position',[-0.25*fieldwidth,-0.25*fieldwidth,...
                              0.5*fieldwidth,0.5*fieldwidth],...
                  'Curvature',[1,1],...
                  'LineWidth',2.5,...
                  'EdgeColor','w')
        %Drawing player paddle
        ppaddle=patch(0,0,'b');
        %Drawing com paddle
        cpaddle=patch(0,0,'r');
        %Drawing ball
        ball=rectangle('Curvature',[1,1],'FaceColor','y');
    end
    %End of DrawField
    %Start of MoveBall
    function MoveBall
        if (ballpos(2)>=((0.5*fieldwidth)-ballradius))||...
           (ballpos(2)<=(ballradius-(0.5*fieldwidth)))
            %Defining ball movement when it hits upper or lower limit
            ballvel(2)=-ballvel(2);
        elseif ballpos(1)<=(ballradius-(0.5*fieldlength))
            %Defining ball movement when it hits left limit
            if (ballpos(2)>ballradius-0.5*goalwidth)&&...
               (ballpos(2)<0.5*goalwidth-ballradius)
                %Reseting ball and paddles due to COM goal
                balldirection=(rand*2*pi())-pi();
                ballpos=[0,0];
                ballvel=[ballinitspeed*cos(balldirection),...
                         ballinitspeed*sin(balldirection)];
                playerpaddlepos=[-0.4*fieldlength,0];
                set(0,'PointerLocation',centermousepos)
                lastmousepos=centermousepos;
                compaddlepos=[0.4*fieldlength,0];
                %Updating score
                comscore=comscore+1;
                set(comscorebox,'String',num2str(comscore))
                set(highlightbox,'Visible','On')
                set(highlightbox,'String','Goal for COM!')
                pause(1)
                set(highlightbox,'Visible','Off')
                %Checking for winner
                if playerscore==goal2win
                    winstat=1;
                elseif comscore==goal2win
                    winstat=2;
                else
                    winstat=0;
                end
            else
                ballvel(1)=-ballvel(1);
            end
        elseif ballpos(1)>=((0.5*fieldlength)-ballradius)
            %Defining ball movement when it hits right limit
            if (ballpos(2)>ballradius-0.5*goalwidth)&&...
               (ballpos(2)<0.5*goalwidth-ballradius)
                %Reseting ball and paddles due to player goal
                balldirection=(rand*2*pi())-pi();
                ballpos=[0,0];
                ballvel=[ballinitspeed*cos(balldirection),...
                         ballinitspeed*sin(balldirection)];
                playerpaddlepos=[-0.4*fieldlength,0];
                set(0,'PointerLocation',centermousepos)
                lastmousepos=centermousepos;
                compaddlepos=[0.4*fieldlength,0];
                %Updating score
                playerscore=playerscore+1;
                set(playerscorebox,'String',num2str(playerscore))
                set(highlightbox,'Visible','On')
                set(highlightbox,'String','Goal for P1!')
                pause(1)
                set(highlightbox,'Visible','Off')
                %Checking for winner
                if playerscore==goal2win
                    winstat=1;
                elseif comscore==goal2win
                    winstat=2;
                else
                    winstat=0;
                end
            else
                ballvel(1)=-ballvel(1);
            end
        elseif (inpolygon(ballpos(1),ballpos(2),...
                          [playerpaddlexdat(1)-ballradius,...
                           playerpaddlexdat(2)+ballradius,...
                           playerpaddlexdat(3)+ballradius,...
                           playerpaddlexdat(4)-ballradius],...
                          [playerpaddleydat(1)-ballradius,...
                           playerpaddleydat(2)-ballradius,...
                           playerpaddleydat(3)+ballradius,...
                           playerpaddleydat(4)+ballradius]))
            %Defining ball movement when it hits player paddles
            ballvel(1)=-ballvel(1);
            %Increasing ball speed
            ballvel=paddlebouncevelratio*ballvel;
            if (inpolygon(ballpos(1)+ballvel(1),ballpos(2)+ballvel(2),...
                          [playerpaddlexdat(1)-0.5*ballradius,...
                           playerpaddlexdat(2)+0.5*ballradius,...
                           playerpaddlexdat(3)+0.5*ballradius,...
                           playerpaddlexdat(4)-0.5*ballradius],...
                          [playerpaddleydat(1)-0.5*ballradius,...
                           playerpaddleydat(2)-0.5*ballradius,...
                           playerpaddleydat(3)+0.5*ballradius,...
                           playerpaddleydat(4)+0.5*ballradius]))
                %Anticipating side paddle impact
                ballvel=-ballvel;
            elseif ballvel(1)>0
                %Deflecting ball movement based on frontal impact position
                ballspeed=norm(ballvel);
                deflect=interp1q([playerpaddleydat(2)-ballradius,...
                                  playerpaddleydat(3)+ballradius]',...
                                  [0.05*pi(),0.95*pi()]',ballpos(2));
                ballvel(1)=ballspeed*cos(deflect-0.5*pi());
                ballvel(2)=ballspeed*sin(deflect-0.5*pi());
            end
        elseif (inpolygon(ballpos(1),ballpos(2),...
                          [compaddlexdat(1)-ballradius,...
                           compaddlexdat(2)+ballradius,...
                           compaddlexdat(3)+ballradius,...
                           compaddlexdat(4)-ballradius],...
                          [compaddleydat(1)-ballradius,...
                           compaddleydat(2)-ballradius,...
                           compaddleydat(3)+ballradius,...
                           compaddleydat(4)+ballradius]))
            %Defining ball movement when it hits player paddles
            ballvel(1)=-ballvel(1);
            %Increasing ball speed
            ballvel=paddlebouncevelratio*ballvel;
            if (inpolygon(ballpos(1)+ballvel(1),ballpos(2)+ballvel(2),...
                          [compaddlexdat(1)-0.5*ballradius,...
                           compaddlexdat(2)+0.5*ballradius,...
                           compaddlexdat(3)+0.5*ballradius,...
                           compaddlexdat(4)-0.5*ballradius],...
                          [compaddleydat(1)-0.5*ballradius,...
                           compaddleydat(2)-0.5*ballradius,...
                           compaddleydat(3)+0.5*ballradius,...
                           compaddleydat(4)+0.5*ballradius]))
                %Anticipating side paddle impact
                ballvel=-ballvel;
            elseif ballvel(1)<0
                %Deflecting ball movement based on frontal impact position
                ballspeed=norm(ballvel);
                deflect=interp1q([compaddleydat(2)-ballradius,...
                                  compaddleydat(3)+ballradius]',...
                                 [0.95*pi(),0.05*pi()]',ballpos(2));
                ballvel(1)=ballspeed*cos(deflect+0.5*pi());
                ballvel(2)=ballspeed*sin(deflect+0.5*pi());
            end
        end
        ballpos=ballpos+ballvel;
        set(speedbox,'String',num2str(norm(ballvel)))
    end
    %End of MoveBall
    %Start of MovePlayerPaddle
    function MovePlayerPaddle
        %Reading mouse movement
        currentmousepos=get(0,'PointerLocation');
        mousespeed=currentmousepos(2)-lastmousepos(2);
        %Moving paddle
        playerpaddlepos(2)=playerpaddlepos(2)+...
                           playerpaddlespeed+...
                           (mousespeed*fieldwidth/(0.8*windowsize(2)));
        %Preventing paddle to go off field
        if playerpaddlepos(2)>=0.5*(fieldwidth-playerpaddlelength)
            playerpaddlepos(2)=0.5*(fieldwidth-playerpaddlelength);
        elseif playerpaddlepos(2)<=-0.5*(fieldwidth-playerpaddlelength)
            playerpaddlepos(2)=-0.5*(fieldwidth-playerpaddlelength);
        end
        playerpaddlexdat=[playerpaddlepos(1)-0.5*playerpaddlethickness,...
                          playerpaddlepos(1)+0.5*playerpaddlethickness,...
                          playerpaddlepos(1)+0.5*playerpaddlethickness,...
                          playerpaddlepos(1)-0.5*playerpaddlethickness];
        playerpaddleydat=[playerpaddlepos(2)-0.5*playerpaddlelength,...
                          playerpaddlepos(2)-0.5*playerpaddlelength,...
                          playerpaddlepos(2)+0.5*playerpaddlelength,...
                          playerpaddlepos(2)+0.5*playerpaddlelength];
        set(0,'PointerLocation',[centermousepos(1),...
                                 centermousepos(2)+...
                                 0.8*windowsize(2)*playerpaddlepos(2)/...
                                 fieldwidth])
        %Saving cursor last position
        lastmousepos(2)=centermousepos(2)+(0.8*windowsize(2)*...
                                           playerpaddlepos(2)/...
                                           fieldwidth);
    end
    %End of MoveComPaddle
    %Start of MoveComPaddle
    function MoveComPaddle
        %Following ball movement
        if compaddlepos(2)<ballpos(2)
            compaddlepos(2)=compaddlepos(2)+((0.5+(rand*0.5))*paddlespeed);
        elseif compaddlepos(2)>ballpos(2)
            compaddlepos(2)=compaddlepos(2)-((0.5+(rand*0.5))*paddlespeed);
        end
        %Preventing paddle to go off screen
        if compaddlepos(2)>=0.5*(fieldwidth-compaddlelength)
            compaddlepos(2)=0.5*(fieldwidth-compaddlelength);
        elseif compaddlepos(2)<=-0.5*(fieldwidth-compaddlelength)
            compaddlepos(2)=-0.5*(fieldwidth-compaddlelength);
        end
        compaddlexdat=[compaddlepos(1)-0.5*compaddlethickness,...
                       compaddlepos(1)+0.5*compaddlethickness,...
                       compaddlepos(1)+0.5*compaddlethickness,...
                       compaddlepos(1)-0.5*compaddlethickness];
        compaddleydat=[compaddlepos(2)-0.5*compaddlelength,...
                       compaddlepos(2)-0.5*compaddlelength,...
                       compaddlepos(2)+0.5*compaddlelength,...
                       compaddlepos(2)+0.5*compaddlelength];
    end
    %End of MoveComPaddle
    %Start of RedrawField
    function RedrawField
        %Redraw player paddle
        set(ppaddle,'XData',playerpaddlexdat)
        set(ppaddle,'YData',playerpaddleydat)
        %Redraw com paddle
        set(cpaddle,'XData',compaddlexdat)
        set(cpaddle,'YData',compaddleydat)
        %Redraw ball
        set(ball,'Position',[ballpos(1)-ballradius,...
                             ballpos(2)-ballradius,...
                             2*ballradius,2*ballradius])
        drawnow
    end
    %End of RedrawField
%Declaring CallbackFunction
    %Start of pressfcn
    function pressfcn(~,event)
        switch event.Key
            case 'w'
                playerpaddlespeed=paddlespeed;
            case 's'
                playerpaddlespeed=-paddlespeed;
            case 'z'
                pausestat=1-pausestat;
                if pausestat==0
                    lastmousepos(1)=centermousepos(1);
                    lastmousepos(2)=centermousepos(2)+...
                                    (0.8*windowsize(2)*...
                                     playerpaddlepos(2)/...
                                     fieldwidth);
                    currentmousepos=lastmousepos;
                    set(0,'PointerLocation',currentmousepos)
                end
            case 'x'
                resetstat=1;
            case 'c'
                playstat=0;
        end
    end
    %End of pressfcn
    %Start of releasefcn
    function releasefcn(~,event)
        switch event.Key
            case 'w'
                playerpaddlespeed=0;
            case 's'
                playerpaddlespeed=0;
        end
    end
    %End of releasefcn
%Executing main script
    %Starting the game
    playstat=1;
    resetstat=1;
    %Executing infinite loop
    while (playstat)&&(winstat==0)
        if resetstat==1
            %Drawing initial field
            DrawField
            %Resetting score and status
            playerscore=0;
            set(playerscorebox,'String',num2str(playerscore))
            comscore=0;
            set(comscorebox,'String',num2str(comscore))
            resetstat=0;
            %Executing count down
            set(highlightbox,'Visible','On')
            set(highlightbox,'String','3')
            pause(1)
            set(highlightbox,'String','2')
            pause(1)
            set(highlightbox,'String','1')
            pause(1)
            set(highlightbox,'String','GO!!!')
            pause(0.25)
            set(highlightbox,'Visible','Off')
            %Centering mouse to paddle
            set(0,'PointerLocation',currentmousepos)
            %Initiating ball movement
            ballspeed=ballinitspeed;
            balldirection=(rand*2*pi())-pi();
            ballpos=[0,0];
            ballvel=[ballspeed*cos(balldirection),...
                     ballspeed*sin(balldirection)];
        end
        if pausestat==0
            %Executing game
            MovePlayerPaddle
            MoveComPaddle
            MoveBall
            RedrawField
            pause(framedelay)
        elseif pausestat==1
            %Pausing game
            pause(framedelay)
        end
    end
    %Announcing winner
    set(highlightbox,'Visible','On')
    if winstat==1
        set(highlightbox,'String','You win!')
        pause(5)
    elseif winstat==2
        set(highlightbox,'String','You lose!')
        pause(5)
    end
    %Quitting game
    close all
%CodeEnd-------------------------------------------------------------------

end