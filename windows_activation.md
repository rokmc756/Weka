## For Windows 10

### Step 1 - Open PowerShell or Command Prompt as administrator

### Step 2 - Install KMS client key
```bash
slmgr /ipk your_license_key
```
Replace `your_license_key` with following volumn license keys according to Windows Edition:
```bash
Home: TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
Home N: 3KHY7-WNT83-DGQKR-F7HPR-844BM
Home Single Language: 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
Home Country Specific: PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
Professional: W269N-WFGWX-YVC9B-4J6C9-T83GX
Professional N: MH37W-N47XK-V7XM9-C7227-GCQG9
Education: NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
Education N: 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
Enterprise: NPPR9-FWDCX-D2C8J-H872K-2YT43
Enterprise N: DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
```

### Step 3 - Set KMS machine address
```bash
slmgr /skms kms_server
```
Replace `kms_server` with the real KMS server address (by online search). For now, the working KMS server is `kms9.msguides.com`.

### Step 4 - Activate your Windows
```bash
slmgr /ato
```

## For Windows Server

### Step 1 - Open PowerShell or Command Prompt as administrator

### Step 2 - Convert Windows Server Evaluation to retail edition
**To get the available editions:**
```bash
DISM /Online /Get-TargetEditions
```

**To set your Windows Server to a higher edition:**
```bash
DISM /online /Set-Edition:ServerStandard /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula
```

### Step 3 - Install KMS client key
```bash
slmgr /ipk your_license_key
```
Replace `your_license_key` with following volumn license keys according to Windows Edition:
```bash
Windows Server 2022 Datacenter: WX4NM-KYWYW-QJJR4-XV3QB-6VM33
Windows Server 2022 Standard: VDYBN-27WPP-V4HQT-9VMD4-VMK7H
Windows Server 2019 Datacenter: WMDGN-G9PQG-XVVXX-R3X43-63DFG
Windows Server 2019 Standard: N69G4-B89J2-4G8F4-WWYCC-J464C
Windows Server 2019 Essentials: WVDHN-86M7X-466P6-VHXV7-YY726
Windows Server 2016 Datacenter: CB7KF-BWN84-R7R2Y-793K2-8XDDG
Windows Server 2016 Standard: WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
Windows Server 2016 Essentials: JCKRF-N37P4-C2D82-9YXRT-4M63B
```

### Step 4 - Set KMS machine address
```bash
slmgr /skms kms_server
```
Replace `kms_server` with the real KMS server address (by online search). For now, the working KMS server is `kms9.msguides.com`.

### Step 5 - Activate your Windows
```bash
slmgr /ato
```