classdef SensorArrayApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        MainWeightsw1w2w3TextArea       matlab.ui.control.TextArea
        MainWeightsw1w2w3TextAreaLabel  matlab.ui.control.Label
        SensorPositionEditField         matlab.ui.control.EditField
        SensorPositionEditFieldLabel    matlab.ui.control.Label
        DifferenceCoarrayTextArea       matlab.ui.control.TextArea
        DifferenceCoarrayTextAreaLabel  matlab.ui.control.Label
        SensorPositionTextArea          matlab.ui.control.TextArea
        SensorPositionTextAreaLabel     matlab.ui.control.Label
        IESNotationEditField            matlab.ui.control.EditField
        IESNotationEditFieldLabel       matlab.ui.control.Label
        InputModeDropDown               matlab.ui.control.DropDown
        InputModeDropDownLabel          matlab.ui.control.Label
        ConversionbetweenvarioussparsesensorarraynotationsLabel  matlab.ui.control.Label
        ProcessButton                   matlab.ui.control.Button
        HolesFreeStatusLabel            matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
    end

    
  

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ProcessButton
        function ProcessButtonPushed(app, event)
            % Get input type from drop-down
            inputType = app.InputModeDropDown.Value;

            if strcmp(inputType, 'IES Notation')
                % Parse IES notation
               notation = str2num(app.IESNotationEditField.Value);
                ar=notation; % Parsed array
            
            % Compute sensor positions
            n = length(ar) + 1;
            b = zeros(1, n);
            for i = 2:n
                b(i) = b(i-1) + ar(i-1);
            end
           app.SensorPositionTextArea.Value = sprintf('%d  ', b);
             a=b;
        else
                inputPositions = str2num(app.SensorPositionEditField.Value);
                a=inputPositions;
                app.SensorPositionTextArea.Value =sprintf('%d ',a);
            end

            % Compute sensor positions
            n = numel(a) ;
           % b = zeros(1, n);
            %for i = 2:n
            %    b(i) = b(i-1) + a(i-1);
           % end
            %app.SensorPositionTextArea.Value = sprintf('%.1f ', b);

            % Compute difference coarray and weights
            x = a - a.';
            d = reshape(x, [1, n * n]);
            dca = unique(sort(d));
            w = histc(d, dca);
            
            % max weights
           % max_a=max(a);
            %main_weights=[w(max_a +2),w(max_a +3), w(max_a + 4)];
            y = zeros(1,max(a)+1);
            y(a+1)=1;
            wa = round(xcorr(y));
            main_weights = [wa(max(a)+2) wa(max(a)+3) wa(max(a)+4)];
            
            % displaying the outputs
            app.DifferenceCoarrayTextArea.Value = sprintf('%s ', mat2str(dca));
            app.MainWeightsw1w2w3TextArea.Value= sprintf('%s', mat2str(main_weights));
            % Plot weight function
            stem(app.UIAxes, dca, w, 'b', 'LineWidth', 1.5);
            xlabel(app.UIAxes, 'Spatial Lags m', 'FontSize', 14, 'Interpreter', 'Latex');
            ylabel(app.UIAxes, 'Weights w(m)', 'FontSize', 14, 'Interpreter', 'Latex');
            grid(app.UIAxes, 'on');

            % Determine hole-free status
            if (length(dca)==2*max(a)+1)
                app.HolesFreeStatusLabel.Text = 'Coarray is Hole-Free';
            else
                app.HolesFreeStatusLabel.Text = 'Coarray is Not Hole-Free';
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9216 0.851 0.5333];
            app.UIFigure.Position = [100 100 1103 507];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Weight Function Graph')
            xlabel(app.UIAxes, 'Spatial Lags')
            ylabel(app.UIAxes, 'Weights')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontWeight = 'bold';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.XMinorGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.YMinorGrid = 'on';
            app.UIAxes.FontSize = 14;
            app.UIAxes.Position = [652 218 410 240];

            % Create HolesFreeStatusLabel
            app.HolesFreeStatusLabel = uilabel(app.UIFigure);
            app.HolesFreeStatusLabel.FontSize = 14;
            app.HolesFreeStatusLabel.FontWeight = 'bold';
            app.HolesFreeStatusLabel.FontAngle = 'italic';
            app.HolesFreeStatusLabel.FontColor = [0 0 1];
            app.HolesFreeStatusLabel.Position = [972 68 273 60];
            app.HolesFreeStatusLabel.Text = 'Holes Free Status';

            % Create ProcessButton
            app.ProcessButton = uibutton(app.UIFigure, 'push');
            app.ProcessButton.ButtonPushedFcn = createCallbackFcn(app, @ProcessButtonPushed, true);
            app.ProcessButton.BackgroundColor = [1 1 1];
            app.ProcessButton.FontSize = 14;
            app.ProcessButton.FontWeight = 'bold';
            app.ProcessButton.FontAngle = 'italic';
            app.ProcessButton.FontColor = [0.851 0.3255 0.098];
            app.ProcessButton.Position = [92 234 133 41];
            app.ProcessButton.Text = 'Process';

            % Create ConversionbetweenvarioussparsesensorarraynotationsLabel
            app.ConversionbetweenvarioussparsesensorarraynotationsLabel = uilabel(app.UIFigure);
            app.ConversionbetweenvarioussparsesensorarraynotationsLabel.FontName = 'Times New Roman';
            app.ConversionbetweenvarioussparsesensorarraynotationsLabel.FontSize = 20;
            app.ConversionbetweenvarioussparsesensorarraynotationsLabel.FontWeight = 'bold';
            app.ConversionbetweenvarioussparsesensorarraynotationsLabel.Position = [258 470 636 26];
            app.ConversionbetweenvarioussparsesensorarraynotationsLabel.Text = 'Difference coarray and weight function analyser for sparse linear arrays';

            % Create InputModeDropDownLabel
            app.InputModeDropDownLabel = uilabel(app.UIFigure);
            app.InputModeDropDownLabel.HorizontalAlignment = 'right';
            app.InputModeDropDownLabel.FontSize = 14;
            app.InputModeDropDownLabel.FontWeight = 'bold';
            app.InputModeDropDownLabel.FontAngle = 'italic';
            app.InputModeDropDownLabel.FontColor = [0.851 0.102 0.102];
            app.InputModeDropDownLabel.Position = [51 426 80 22];
            app.InputModeDropDownLabel.Text = 'Input Mode';

            % Create InputModeDropDown
            app.InputModeDropDown = uidropdown(app.UIFigure);
            app.InputModeDropDown.Items = {'IES Notation', 'Sensor Positions', ''};
            app.InputModeDropDown.Position = [146 426 233 22];
            app.InputModeDropDown.Value = 'IES Notation';

            % Create IESNotationEditFieldLabel
            app.IESNotationEditFieldLabel = uilabel(app.UIFigure);
            app.IESNotationEditFieldLabel.HorizontalAlignment = 'right';
            app.IESNotationEditFieldLabel.FontSize = 14;
            app.IESNotationEditFieldLabel.FontWeight = 'bold';
            app.IESNotationEditFieldLabel.FontAngle = 'italic';
            app.IESNotationEditFieldLabel.FontColor = [0.851 0.102 0.102];
            app.IESNotationEditFieldLabel.Position = [51 376 88 22];
            app.IESNotationEditFieldLabel.Text = 'IES Notation';

            % Create IESNotationEditField
            app.IESNotationEditField = uieditfield(app.UIFigure, 'text');
            app.IESNotationEditField.Position = [154 376 228 22];

            % Create SensorPositionTextAreaLabel
            app.SensorPositionTextAreaLabel = uilabel(app.UIFigure);
            app.SensorPositionTextAreaLabel.HorizontalAlignment = 'right';
            app.SensorPositionTextAreaLabel.FontSize = 14;
            app.SensorPositionTextAreaLabel.FontWeight = 'bold';
            app.SensorPositionTextAreaLabel.FontAngle = 'italic';
            app.SensorPositionTextAreaLabel.FontColor = [0 0 1];
            app.SensorPositionTextAreaLabel.Position = [11 104 115 22];
            app.SensorPositionTextAreaLabel.Text = 'Sensor Position ';

            % Create SensorPositionTextArea
            app.SensorPositionTextArea = uitextarea(app.UIFigure);
            app.SensorPositionTextArea.Position = [141 78 170 50];

            % Create DifferenceCoarrayTextAreaLabel
            app.DifferenceCoarrayTextAreaLabel = uilabel(app.UIFigure);
            app.DifferenceCoarrayTextAreaLabel.HorizontalAlignment = 'right';
            app.DifferenceCoarrayTextAreaLabel.FontSize = 14;
            app.DifferenceCoarrayTextAreaLabel.FontWeight = 'bold';
            app.DifferenceCoarrayTextAreaLabel.FontAngle = 'italic';
            app.DifferenceCoarrayTextAreaLabel.FontColor = [0 0 1];
            app.DifferenceCoarrayTextAreaLabel.Position = [322 104 130 22];
            app.DifferenceCoarrayTextAreaLabel.Text = 'Difference Coarray';

            % Create DifferenceCoarrayTextArea
            app.DifferenceCoarrayTextArea = uitextarea(app.UIFigure);
            app.DifferenceCoarrayTextArea.Position = [467 78 216 50];

            % Create SensorPositionEditFieldLabel
            app.SensorPositionEditFieldLabel = uilabel(app.UIFigure);
            app.SensorPositionEditFieldLabel.HorizontalAlignment = 'right';
            app.SensorPositionEditFieldLabel.FontSize = 14;
            app.SensorPositionEditFieldLabel.FontWeight = 'bold';
            app.SensorPositionEditFieldLabel.FontAngle = 'italic';
            app.SensorPositionEditFieldLabel.FontColor = [0.851 0.102 0.102];
            app.SensorPositionEditFieldLabel.Position = [51 316 114 22];
            app.SensorPositionEditFieldLabel.Text = 'Sensor Position';

            % Create SensorPositionEditField
            app.SensorPositionEditField = uieditfield(app.UIFigure, 'text');
            app.SensorPositionEditField.Position = [179 316 210 22];

            % Create MainWeightsw1w2w3TextAreaLabel
            app.MainWeightsw1w2w3TextAreaLabel = uilabel(app.UIFigure);
            app.MainWeightsw1w2w3TextAreaLabel.HorizontalAlignment = 'right';
            app.MainWeightsw1w2w3TextAreaLabel.FontSize = 14;
            app.MainWeightsw1w2w3TextAreaLabel.FontWeight = 'bold';
            app.MainWeightsw1w2w3TextAreaLabel.FontAngle = 'italic';
            app.MainWeightsw1w2w3TextAreaLabel.FontColor = [0 0 1];
            app.MainWeightsw1w2w3TextAreaLabel.Position = [702 92 97 34];
            app.MainWeightsw1w2w3TextAreaLabel.Text = {'Main Weights'; 'w(1) w(2) w(3)'};

            % Create MainWeightsw1w2w3TextArea
            app.MainWeightsw1w2w3TextArea = uitextarea(app.UIFigure);
            app.MainWeightsw1w2w3TextArea.FontColor = [0.3137 0.5098 0.0627];
            app.MainWeightsw1w2w3TextArea.Position = [814 78 150 50];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SensorArrayApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end