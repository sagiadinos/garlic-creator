function Component(){}

Component.prototype.createOperations = function()
{
    try
    {
        if (installer.value("os") === "win" && installer.value("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\VisualStudio\\14.0\\VC\\Runtimes\\X644\\Installed) !== 1)
        {
            component.createOperations();
            component.addElevatedOperation("Execute", "@TargetDir@/vcredist_x64.exe", "/quiet", "/norestart");
            component.addElevatedOperation("Delete", "@TargetDir@/vcredist_x64.exe");
        }
    }
    catch (e)
    {
        print(e);
    }
}
