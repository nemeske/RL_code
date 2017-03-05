function startup(width,length,ball_speed,paddle_speed,visible)
%%%%%%%% TODO %%%%%%%%%
% Two player mode flag
% Redrawfield. - Distunguish the AI paddle moving in the future from the
% player.
%               - Moving ball
% Border touching
%% Declaring global variables and initializing them

ScreenSize=get(0,'ScreenSize');
% global ball ppaddle cpaddle
goal2win=5;
windowsize=[800,400];
fieldlength=length; % def 200
fieldwidth=width; % def 100
goalwidth=ceil(width/4); % round to +inf
l_to_w = fieldlength/fieldwidth;
ball = [];
%player_paddlepos=[-0.4*fieldlength,0];
player_paddlespeed=0;
player_paddle1 = [];
player_paddle2 = [];
player_paddle = [player_paddle1 player_paddle2];
ai_paddle1 = [];
ai_paddle2 = [];
ai_paddle = [ai_paddle1 ai_paddle2];
paddle_width = 2;
paddle_length =20;
%ai_addlepos=[0.4*fieldlength,0];
ai_paddlespeed = 0;
%ai_paddlexdat=[];
%ai_paddleydat=[];
ballradius=3;
ballinitspeed=ball_speed;
% Starting from the centre of map, random direction
balldirection=rand*2*pi(); 
ballpos=[0,0];
ballspeed_xy=[ballinitspeed*cos(balldirection),...
         ballinitspeed*sin(balldirection)];
wait=0.05;
isgoal = 0; % 1 for player, 2 for AI
player1_base = [-2/3*fieldlength/2, -0.5*paddle_length,...
                paddle_width,paddle_length];
player2_base = [1/3*fieldlength/2, -0.5*paddle_length,...
                paddle_width,paddle_length];
ai1_base = [2/3*fieldlength/2, -0.5*paddle_length,...
                paddle_width,paddle_length];
ai2_base = [-1/3*fieldlength/2, -0.5*paddle_length,...
                paddle_width,paddle_length];
ball_base = [-ballradius, -ballradius,...
                2*ballradius,2*ballradius];
playstat=0;
%pausestat=0;
resetstat=0;
winstat=0;
player_score=0;
ai_score=0;

%% Generating main window

% Main window
mainwindow=figure('Name','Namenotknown',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-windowsize(1)),...
                                  0.5*(ScreenSize(4)-windowsize(2)),...
                                  windowsize(1),windowsize(2)],... % left bottom width height
                      'KeyPressFcn',@KeyPress,... 
                      'KeyReleaseFcn',@KeyRelease); 
                      
% Creating a plot with the length and width given. 
% The origo of the game will be in the centre of the field                      
axes('Parent',mainwindow,...
         'Position',[0.1,0.15,0.8,0.8],...
         'XLimMode','manual',...
         'XLim',[-0.5*fieldlength 0.5*fieldlength],...
         'YLimMode','manual',...
         'YLim',[-0.5*fieldwidth 0.5*fieldwidth]);
 %% Local functions
 % In order not to overuse global variable we use nested functions creating
 % the game. There will be an opportunitiy to run the game without
 % visualizing is.
 
    function DrawField
        % The function draws the field
        figure(mainwindow);
        axis equal
        axis([-0.5*fieldlength,0.5*fieldlength,...
              -0.5*fieldwidth 0.5*fieldwidth]);
        % axis off % making the coords invisible
        hold on
        
        % Background
        rectangle('Position',[-0.5*fieldlength,-0.5*fieldwidth,...
                              fieldlength,fieldwidth],...
                  'FaceColor',[0 80/255 4/255],...
                  'LineStyle','none');
        % Border 1      
          line([-0.5*fieldlength,-0.5*fieldlength,...
              0.5*fieldlength,0.5*fieldlength],...
             [0.5*goalwidth,0.5*fieldwidth,...
              0.5*fieldwidth,0.5*goalwidth],...
             'LineWidth',5,...
             'Color','w');
         % Border 2
         line([-0.5*fieldlength,-0.5*fieldlength,...
              0.5*fieldlength,0.5*fieldlength],...
             [-0.5*goalwidth,-0.5*fieldwidth,...
              -0.5*fieldwidth,-0.5*goalwidth],...
             'LineWidth',5,...
             'Color','w');
         % Halftrack
         line([0,0],[-0.5*fieldwidth,0.5*fieldwidth],...
             'LineWidth',2.5,'Color','w');
         % Half circle
         rectangle('Position',[-0.15*fieldwidth,-0.15*fieldwidth,...
                              2*0.15*fieldwidth,2*0.15*fieldwidth],... % x y w h
                  'Curvature',[1 1],...
                  'LineWidth',2.5,...
                  'EdgeColor','w');
        % Starting point
        rectangle('Position',[-0.01*fieldwidth,-0.01*fieldwidth,...
                              2*0.01*fieldwidth,2*0.01*fieldwidth],... % x y w h 
                  'Curvature',[1 1],...
                  'LineWidth',2.5,...
                  'EdgeColor','w');
              
        % Player paddles
        player_paddle1 = rectangle('Position',player1_base,...
                                            'FaceColor','b');
        player_paddle2 = rectangle('Position',player2_base,...
                                            'FaceColor','b');
        
        %AI paddles                               
        ai_paddle1 = rectangle('Position',ai1_base,...
                                            'FaceColor','r');
        ai_paddle2 = rectangle('Position',ai2_base,...
                                            'FaceColor','r');
      

        ball=rectangle('Position',ball_base,...
                              'Curvature',[1,1],...
                              'FaceColor',[220/255 240/255 0]);
    end

    function KeyPress(hObject, eventdata, handles)
       % Key press down callback. 
       % The W and S controlls the player, and the uparrow and downarrow
       % controlls the AI (for a short time it is a second player)
       switch eventdata.Key
           case 'w'
               player_paddlespeed = paddle_speed;
           case 's'
               player_paddlespeed = -paddle_speed;
           case 'uparrow'
               ai_paddlespeed = paddle_speed;
           case 'downarrow'
               ai_paddlespeed = -paddle_speed;
       end
    end
    
    function KeyRelease(hObject, eventdata, handles)
    % if a key is released stop the paddles
       switch eventdata.Key
           case 'w'
               player_paddlespeed = 0;
           case 's'
               player_paddlespeed = 0;
           case 'uparrow'
               ai_paddlespeed = 0;
           case 'downarrow'
               ai_paddlespeed = 0;
       end
    end
    function BallMove
        % The functiton moves the ball. The following cases will be
        % handled: 
        %   - Encounter with the upper and lower border
        %   - Encounter with the left and right border
        %   - Encounter with one of the paddles
            if ballpos(2) >= fieldwidth/2 - 2*ballradius || ... % upper border
               ballpos(2) <= -fieldwidth/2  % lower border 
           % Asymetric because the ball is a 'rectangle' function, and the 
           % bottom left corner is (0,0)
               ballspeed_xy(2) = - ballspeed_xy(2);
            end
            % Hit the left or right border but not goal
            if ballpos(1) >= fieldlength/2 - 2*ballradius || ... % right border
               ballpos(1) <= -fieldlength/2   % left border
                if -goalwidth/2 <= ballpos(2) && ballpos(2) <= goalwidth/2
                    % GOAL
                    if ballpos(1) > 0
                        isgoal = 1; % Player goal
                    else
                        isgoal = 2; % AI goal
                    end
                    return;                    
                else
                    ballspeed_xy(1) = - ballspeed_xy(1); % bounce
                end
            end
            
            % Checking collision with paddles
            
            %Player paddle 1
            ppos1 = get(player_paddle1,'Position');
            % ppos1(1) and ppos(2) defines the lower left corner

            if ( (ballpos(2) >= ppos1(2)) && (ballpos(2)+ 2*ballradius <= ppos1(2)+paddle_length)) &&...
               ((ballpos(1) + 2*ballradius >= ppos1(1)) && (ballpos(1) <= ppos1(1)+paddle_width))
                ballspeed_xy(2) = ballspeed_xy(2) + player_paddlespeed; % addig vertical speed
                ballspeed_xy(1) = -ballspeed_xy(1); % bouncing
            end
            
            %Player paddle 2
            ppos2 = get(player_paddle2,'Position');
            if ( (ballpos(2) >= ppos2(2)) && (ballpos(2)+ 2*ballradius <= ppos2(2)+paddle_length)) &&...
               ((ballpos(1) + 2*ballradius >= ppos2(1)) && (ballpos(1) <= ppos2(1)+paddle_width))
                ballspeed_xy(2) = ballspeed_xy(2) + player_paddlespeed; % addig vertical speed
                ballspeed_xy(1) = -ballspeed_xy(1); % bouncing
            end
            
            % AI paddle 1
            aipos1 = get(ai_paddle1,'Position');
            if ( (ballpos(2) >= aipos1(2)) && (ballpos(2)+ 2*ballradius <= aipos1(2)+paddle_length))&&...
               ((ballpos(1) + 2*ballradius >= aipos1(1)) && (ballpos(1) <= aipos1(1)+paddle_width))
                ballspeed_xy(2) = ballspeed_xy(2) + player_paddlespeed; % addig vertical speed
                ballspeed_xy(1) = -ballspeed_xy(1); % bouncing
            end
            
            % AI paddle 2
            aipos2 = get(ai_paddle2,'Position');
            if ( (ballpos(2) >= aipos2(2)) && (ballpos(2)+ 2*ballradius <= aipos2(2)+paddle_length))&&...
               ((ballpos(1) + 2*ballradius >= aipos2(1)) && (ballpos(1) <= aipos2(1)+paddle_width))
                ballspeed_xy(2) = ballspeed_xy(2) + player_paddlespeed; % addig vertical speed
                ballspeed_xy(1) = -ballspeed_xy(1); % bouncing
            end
            ballpos = ballpos + ballspeed_xy;
    end
    function RedrawField
        % The function moves the paddles and the ball at the first place
        % Getting the current position
        currpos_player1 = get(player_paddle1,'Position');
        currpos_ai1 = get(ai_paddle1,'Position');
        currpos_player2 = get(player_paddle2,'Position');
        currpos_ai2 = get(ai_paddle2,'Position');
        
        % Adding the speed
        nextpos_player1 = currpos_player1;
        nextpos_player1(2) = nextpos_player1(2)  + player_paddlespeed;
        nextpos_player2 = currpos_player2;
        nextpos_player2(2) = nextpos_player2(2)  + player_paddlespeed;
        
        nextpos_ai1 = currpos_ai1;
        nextpos_ai1(2) = nextpos_ai1(2) + ai_paddlespeed;
        nextpos_ai2 = currpos_ai2;
        nextpos_ai2(2) = nextpos_ai2(2) + ai_paddlespeed;
        
        % Checking if the paddle if out ot the field
        % Upper border
        if nextpos_player1(2)+paddle_length >= fieldwidth/2
            nextpos_player1(2) = (fieldwidth/2 - paddle_length );
            nextpos_player2(2) = (fieldwidth/2 - paddle_length  );
        end
        
        if nextpos_ai1(2)+paddle_length >= fieldwidth/2  
            nextpos_ai1(2) = (fieldwidth/2 - paddle_length);
            nextpos_ai2(2) = (fieldwidth/2 - paddle_length);
        end
        
        % Lower border
        if nextpos_player1(2) <= -fieldwidth/2 + 1.125 % linewidth
            nextpos_player1(2) = -fieldwidth/2 + 1.125;
            nextpos_player2(2) = -fieldwidth/2  + 1.125;
        end
        
        if nextpos_ai1(2) <= -fieldwidth/2 + 1.125 
            nextpos_ai1(2) = -fieldwidth/2 + 1.125;
            nextpos_ai2(2) = -fieldwidth/2 + 1.125;
        end       
        % Displaying the result
        set(player_paddle1,'Position',nextpos_player1);
        set(ai_paddle1,'Position',nextpos_ai1);
        set(player_paddle2,'Position',nextpos_player2);
        set(ai_paddle2,'Position',nextpos_ai2);
        
        % Updating ball postion
        currballpos = get(ball,'Position');
        nextballpos = currballpos;
        %nextballpos(1:2) = currballpos(1:2) + ballpos;
        nextballpos(1:2) =  ballpos;
        set(ball,'Position',nextballpos);
    end
        
           
DrawField;
while(1)
    if isgoal ~= 0
        % If goal
        
        if isgoal == 1
            waitfor(msgbox('Player goal'));
        else
            waitfor(msgbox('AI goal'));
        end
        % RESETTING GAME
        pause(1);
        figure(mainwindow);
        hold on;
        set(player_paddle1,'Position',player1_base);
        set(player_paddle2,'Position',player2_base);
        set(ai_paddle1,'Position',ai1_base);
        set(ai_paddle2,'Position',ai2_base);
        set(ball,'Position',ball_base);
        hold off;
        balldirection=rand*2*pi(); 
        ballpos=[0,0];
        ballspeed_xy=[ballinitspeed*cos(balldirection),...
                    ballinitspeed*sin(balldirection)];
        player_paddlespeed = 0;
        ai_paddlespeed = 0;
        isgoal = 0;
    end
            
    BallMove;
    RedrawField;
    pause(wait);
end
end % end of main function
 
 