Extended from Grimthorr (https://gist.github.com/Grimthorr) at https://gist.github.com/Grimthorr/44727ea8cf5d3df11cf7

$servers = Get-Content C:\servers.txt

foreach ($server in $servers){
    if (Test-Connection -ComputerName $server -Quiet -ErrorAction SilentlyContinue){
        
        $s = New-PSSession -ComputerName $server -Name $server -ErrorAction SilentlyContinue

        $server
        Invoke-Command -ComputerName $server {
        $UpdateSession = New-Object -ComObject Microsoft.Update.Session;
        $UpdateSearcher = $UpdateSession.CreateupdateSearcher();
        $Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates);
        $updatecount = $Updates | Measure-Object | Format-Table -Property Count -AutoSize -HideTableHeaders;
        if ($updatecount -eq 0){Write-Output "No updates available"}else{$updatecount}
        }

        Remove-PSSession -Session $s -ErrorAction SilentlyContinue
        }
    else {
        Write-Output "$server not responding"
        }
}
