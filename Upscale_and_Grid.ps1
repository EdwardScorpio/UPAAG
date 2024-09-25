Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$ErrorActionPreference = "SilentlyContinue" 
$ProgressPreference = 'SilentlyContinue' 
Out-Null 
# Load translations
$translations = @{}
Get-Content -Path "translations.txt" -Encoding UTF8 | ForEach-Object {
    $key, $value = $_ -split '=', 2
    $translations[$key.Trim()] = $value.Trim()
}

# Function to get translation
function GetTranslation($key) {
    if ($translations.ContainsKey($key)) {
        return $translations[$key]
    }
    return $key
}

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="{TITLE}" Height="350" Width="500" WindowStartupLocation="CenterScreen">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Label Grid.Row="0" Grid.Column="0" Content="{CHOOSE_FILE}" x:Name="ChooseFileLabel" VerticalAlignment="Center"/>
        <Grid Grid.Row="0" Grid.Column="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <TextBox Grid.Column="0" x:Name="FilePathTextBox" IsReadOnly="True" Margin="0,5,5,5"/>
            <Button Grid.Column="1" Content="..." Width="30" x:Name="ChooseFileButton"/>
        </Grid>

        <Label Grid.Row="1" Grid.Column="0" Content="{SCALE_FACTORS}" VerticalAlignment="Center"/>
        <StackPanel Grid.Row="1" Grid.Column="1" Orientation="Horizontal">
            <Button Content="5" Width="30" x:Name="Scale5Button" Margin="2"/>
            <Button Content="6" Width="30" x:Name="Scale6Button" Margin="2"/>
            <Button Content="7" Width="30" x:Name="Scale7Button" Margin="2"/>
            <Button Content="8" Width="30" x:Name="Scale8Button" Margin="2"/>
            <Button Content="9" Width="30" x:Name="Scale9Button" Margin="2"/>
            <Button Content="10" Width="30" x:Name="Scale10Button" Margin="2"/>
        </StackPanel>

        <TextBox Grid.Row="2" Grid.Column="1" x:Name="ScaleFactorTextBox" Margin="0,5"/>
        <TextBlock Grid.Row="3" Grid.Column="1" x:Name="OutputResolutionTextBlock" Margin="0,5" Foreground="Gray"/>

        <Label Grid.Row="4" Grid.Column="0" Content="{GRID_OPTIONS}" VerticalAlignment="Top"/>
        <StackPanel Grid.Row="4" Grid.Column="1" Orientation="Vertical">
            <CheckBox Content="{ENABLE_GRID}" IsChecked="True" x:Name="EnableGridCheckBox"/>
            <ComboBox x:Name="GridColorComboBox" Width="150" Margin="0,5" HorizontalAlignment="Left">
                <ComboBoxItem Content="{BLACK}" IsSelected="True"/>
                <ComboBoxItem Content="{RED}"/>
                <ComboBoxItem Content="{GREEN}"/>
                <ComboBoxItem Content="{BLUE}"/>
                <ComboBoxItem Content="{YELLOW}"/>
            </ComboBox>
            <CheckBox Content="{SAVE_WITHOUT_GRID}" x:Name="SaveWithoutGridCheckBox"/>
            <CheckBox Content="{OPEN_FOLDER}" x:Name="OpenFolderCheckBox"/>
        </StackPanel>

<TextBlock Grid.Row="6" Grid.Column="0" 
           HorizontalAlignment="Left" VerticalAlignment="Bottom" 
           Margin="5" Text="Made by Edward Scoprio" 
           FontSize="10" Foreground="Gray"/>

        <Button Grid.Row="5" Grid.Column="1" Content="{EXECUTE}" x:Name="ExecuteButton" Margin="0,10" Width="100" HorizontalAlignment="Left"/>
        <TextBlock Grid.Row="6" Grid.Column="0" Grid.ColumnSpan="2" x:Name="StatusTextBlock" Foreground="Green" TextWrapping="Wrap"/>
		
    </Grid>
</Window>
"@

# Применяем переводы к XAML
$xaml = $xaml.Replace("{TITLE}", (GetTranslation "Upscale and Grid"))
$xaml = $xaml.Replace("{CHOOSE_FILE}", (GetTranslation "Choose file:"))
$xaml = $xaml.Replace("{SCALE_FACTORS}", (GetTranslation "Scale factors:"))
$xaml = $xaml.Replace("{GRID_OPTIONS}", (GetTranslation "Grid options:"))
$xaml = $xaml.Replace("{ENABLE_GRID}", (GetTranslation "Enable Grid"))
$xaml = $xaml.Replace("{BLACK}", (GetTranslation "Black"))
$xaml = $xaml.Replace("{RED}", (GetTranslation "Red"))
$xaml = $xaml.Replace("{GREEN}", (GetTranslation "Green"))
$xaml = $xaml.Replace("{BLUE}", (GetTranslation "Blue"))
$xaml = $xaml.Replace("{YELLOW}", (GetTranslation "Yellow"))
$xaml = $xaml.Replace("{SAVE_WITHOUT_GRID}", (GetTranslation "Save without Grid also"))
$xaml = $xaml.Replace("{OPEN_FOLDER}", (GetTranslation "Open folder after saving"))
$xaml = $xaml.Replace("{EXECUTE}", (GetTranslation "Execute"))

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
$window = [Windows.Markup.XamlReader]::Load($reader)

$filePathTextBox = $window.FindName("FilePathTextBox")
$scaleFactorTextBox = $window.FindName("ScaleFactorTextBox")
$outputResolutionTextBlock = $window.FindName("OutputResolutionTextBlock")
$gridColorComboBox = $window.FindName("GridColorComboBox")
$enableGridCheckBox = $window.FindName("EnableGridCheckBox")
$saveWithoutGridCheckBox = $window.FindName("SaveWithoutGridCheckBox")
$openFolderCheckBox = $window.FindName("OpenFolderCheckBox")
$chooseFileButton = $window.FindName("ChooseFileButton")
$executeButton = $window.FindName("ExecuteButton")
$statusTextBlock = $window.FindName("StatusTextBlock")

$statusTextBlock = $window.FindName("StatusTextBlock")

# Применяем переводы к элементам интерфейса
$window.Title = GetTranslation("Upscale and Grid")
$window.FindName("ChooseFileLabel").Content = GetTranslation("Choose file:")
$executeButton.Content = GetTranslation("Execute")
$window.FindName("Scale5Button").Content = GetTranslation("5")
$window.FindName("Scale6Button").Content = GetTranslation("6")
$window.FindName("Scale7Button").Content = GetTranslation("7")
$window.FindName("Scale8Button").Content = GetTranslation("8")
$window.FindName("Scale9Button").Content = GetTranslation("9")
$window.FindName("Scale10Button").Content = GetTranslation("10")
$window.FindName("EnableGridCheckBox").Content = GetTranslation("Enable Grid")
$window.FindName("SaveWithoutGridCheckBox").Content = GetTranslation("Save without Grid also")
$window.FindName("OpenFolderCheckBox").Content = GetTranslation("Open folder after saving")

# Переводим элементы ComboBox
$gridColorComboBox.Items.Clear()
@("Black", "Red", "Green", "Blue", "Yellow") | ForEach-Object {
    $item = New-Object System.Windows.Controls.ComboBoxItem
    $item.Content = GetTranslation($_)
    $gridColorComboBox.Items.Add($item)
} | Out-Null
$gridColorComboBox.SelectedIndex = 0

$scaleButtons = @(
    $window.FindName("Scale5Button"),
    $window.FindName("Scale6Button"),
    $window.FindName("Scale7Button"),
    $window.FindName("Scale8Button"),
    $window.FindName("Scale9Button"),
    $window.FindName("Scale10Button")
)

$chooseFileButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = GetTranslation("Image files (*.png;*.jpg;*.bmp)|*.png;*.jpg;*.bmp")
    $result = $openFileDialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $filePathTextBox.Text = $openFileDialog.FileName
        UpdateResolution
    }
})

function UpdateResolution {
    param()
    $inputPath = $filePathTextBox.Text
    $scaleFactor = [int]$scaleFactorTextBox.Text
    if ($inputPath -and $scaleFactor) {
        $img = [System.Drawing.Image]::FromFile($inputPath)
        $newWidth = $img.Width * $scaleFactor
        $newHeight = $img.Height * $scaleFactor
        $outputResolutionTextBlock.Text = "Output resolution: $newWidth x $newHeight"
        $img.Dispose()
    } else {
        $outputResolutionTextBlock.Text = ""
    }
}

foreach ($btn in $scaleButtons) {
    $btn.Add_Click({
        $scaleFactorTextBox.Text = $this.Content
        UpdateResolution
    })
}

$scaleFactorTextBox.Add_TextChanged({
    UpdateResolution
})

$executeButton.Add_Click({
    $inputPath = $filePathTextBox.Text
    $scaleFactor = [int]$scaleFactorTextBox.Text

    if (-not $inputPath -or -not $scaleFactor) {
        $statusTextBlock.Text = GetTranslation("Please select a file and enter a scale factor.")
        $statusTextBlock.Foreground = [System.Windows.Media.Brushes]::Red
        return
    }

    try {
        $img = [System.Drawing.Image]::FromFile($inputPath)
        $newWidth = $img.Width * $scaleFactor
        $newHeight = $img.Height * $scaleFactor

$gridColorText = ($gridColorComboBox.SelectedItem).Content
$gridColor = switch ($gridColorText) {
    (GetTranslation "Black") { [System.Drawing.Color]::Black }
    (GetTranslation "Red") { [System.Drawing.Color]::Red }
    (GetTranslation "Green") { [System.Drawing.Color]::Green }
    (GetTranslation "Blue") { [System.Drawing.Color]::Blue }
    (GetTranslation "Yellow") { [System.Drawing.Color]::Yellow }
    default { [System.Drawing.Color]::Black }
}


        $bitmap = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half

        $graphics.DrawImage($img, 0, 0, $newWidth, $newHeight)

        if ($enableGridCheckBox.IsChecked) {
            $pen = New-Object System.Drawing.Pen($gridColor)
            for ($x = 0; $x -lt $newWidth; $x += $scaleFactor) {
                $graphics.DrawLine($pen, $x, 0, $x, $newHeight)
            }
            for ($y = 0; $y -lt $newHeight; $y += $scaleFactor) {
                $graphics.DrawLine($pen, 0, $y, $newWidth, $y)
            }
            $pen.Dispose()
        }

        $directory = [System.IO.Path]::GetDirectoryName($inputPath)
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($inputPath)
        $extension = [System.IO.Path]::GetExtension($inputPath)
        $outputPath = Join-Path $directory "$fileName`_Scale_$($scaleFactor)x$extension"

        # Check if file exists and add number if necessary
        $counter = 1
        while (Test-Path $outputPath) {
            $outputPath = Join-Path $directory "$fileName`_Scale_$($scaleFactor)x_$counter$extension"
            $counter++
        }

        $bitmap.Save($outputPath)

        if ($saveWithoutGridCheckBox.IsChecked) {
            $bitmapNoGrid = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
            $graphicsNoGrid = [System.Drawing.Graphics]::FromImage($bitmapNoGrid)
            $graphicsNoGrid.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
            $graphicsNoGrid.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
            $graphicsNoGrid.DrawImage($img, 0, 0, $newWidth, $newHeight)
            $outputPathNoGrid = Join-Path $directory "$fileName`_Scale_$($scaleFactor)x_NoGrid$extension"
            $bitmapNoGrid.Save($outputPathNoGrid)
            $graphicsNoGrid.Dispose()
            $bitmapNoGrid.Dispose()
        }

        $graphics.Dispose()
        $bitmap.Dispose()
        $img.Dispose()

        $statusTextBlock.Text = GetTranslation("Done!:") + " $outputPath"
        $statusTextBlock.Foreground = [System.Windows.Media.Brushes]::Green

        if ($openFolderCheckBox.IsChecked) {
            Start-Process explorer.exe -ArgumentList "/select,`"$outputPath`""
        }
    }
    catch {
        $statusTextBlock.Text = GetTranslation("An error occurred:") + " $_"
        $statusTextBlock.Foreground = [System.Windows.Media.Brushes]::Red
    }
})

$window.ShowDialog() | Out-Null