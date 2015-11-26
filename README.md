## Windows 10 Configurator

 **Contents**
 
- Intro
- How to Use
- Things it Changes Automatically
- Things it Guides You Through
- Contact
- Sources

### Intro
Windows 10 comes with an abundance of highly questionable tracking, logging and insecure settings as well as the usual mandatory Metro apps. These settings do not belong baked into an Operating System and it doesn't bode well for the future of Windows. This script automates the process of disabling these settings on a new install and to make it easier for less technically inclined people to do so as well.

If you want to do these things manually, you can either read the source (it's just a batch file) or follow the steps here: https://drive.google.com/open?id=15gsUSSmgpxxS94Gj0LlenJ-nPPhXx0UNeBuv4Lv6FCI


### How to Use 
Mandatory Disclaimer: This software is provided without guarantee or warranty and I (the author) am not responsible for anything that goes wrong (not that it should).	

1. Download the zip and extract everything to a directory of your choice
2. Run "windows10_configurator.bat" and click "Yes" on the Run as Admin prompt that opens. It needs this to edit the registry and disable services.
3. Follow the instructions in the window that opens. 
 - You can skip any setting by replying "N" when it prompts you
 - Some settings have different configurations options with the recommended one marked with "[Recommended]"
4. After the automatic stage, the Configurator will guide you through some settings you need to disable in the default Settings app (as I was unable to figure out how to automate them).

	
### Things it Changes Automatically
1. Delivery Optimisation  
	Lets Windows share app and update files over the internet and LAN in a peer-to-peer fashion. This is a possible security risk, however you may like to set it to LAN only for faster updates on multiple PCs.
2. Auto Update  
	Allows you to change how updates are downloaded and whether they are automatically installed. By default they are installed automatically
3. Data Collection  
	Windows collects a lot of data about how you use the computer, including things you type, which is uploaded to their servers.
4. OneDrive  
	OneDrive (formerly SkyDrive) is Microsoft's cloud sync client which is enabled by default and is plastered everywhere. This setting will disable it. Obviously if you use OneDrive, skip this setting.
5. Application & Customer Experience Logging  
	Windows has several tasks that perform the gathering and uploading of app usage data.
6. Hosts File Entries  
	As an extra precaution, you can prevent Windows from being able to access Microsoft tracking servers. This will redirect all requests to these servers to an invalid IP (0.0.0.0) by editing your hosts file. (with these http://pastey.org/view/658d98bc)
7. Metro Apps  
	Windows comes with a lot of mandatory Metro (tablet) apps which you may not want. You can uninstall them all with this setting. WARNING: there is no easy way of getting these apps back!

	
### Things it Guides You Through
1. WiFi Sense  
	Windows wants to try and share your WiFi passwords with your contacts, and Facebook and Skype friends. This is a potential security risk.
2. Sync Settings  
	When using a Microsoft account, Windows uploads arguably more data than you actually need to sync with your devices. To fix this, you can either use a Local Account (disabling sync completely), or turn off settings you don't need.
3. Privacy & Feedback  
	Apps have access to a lot of data by default, most of which is unnecessary. Also, another Telemetry precaution is to change when and what feedback is sent. Note that Windows should be unable to send feedback at all if you used all of the automatic settings.
4. Ad Tracking  
	Each Windows 10 computer has a unique advertising ID which can be used to track the user and provide targeted ads.
5. Cortana  
	If you don't have a burning reason to use Cortana, it's recommended to disable it as Microsoft store everything you say and type to it.	
6. CCleaner Config  
	If you use CCleaner and Windows Defender you need to disable the cleaning of Defender files otherwise Windows won't be able to update Defender's malware definitions	
	
	
### Sources 
- https://www.reddit.com/r/pcmasterrace/comments/3f10k0/things_to_removedisable_in_windows_10
- https://www.reddit.com/r/pcmasterrace/comments/3f10k0/things_to_removedisable_in_windows_10/ctkmplz
- http://windows.microsoft.com/en-us/windows-10/windows-update-delivery-optimization-faq
- http://www.addictivetips.com/windows-tips/how-to-remove-all-stock-third-party-modern-ui-apps-from-windows-8-rt
- https://www.reddit.com/r/Windows10/comments/31rxsv/disable_keylogger_windows_10/
- http://thepcwhisperer.blogspot.co.uk/2014/10/microsofts-windows-10-preview-has-built.html
- https://www.reddit.com/r/Windows10/comments/3f38ed/guide_how_to_disable_data_logging_in_w10/


