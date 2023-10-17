# sieve-script
A PowerShell script to generate mappings for SieveProcessor (Fluent API) for Sieve library (C#). 

```
.\sieve_mapper_generator.ps1 -sourceFolder "C:\Users\test\source\repos\work\helutrans\ams\api3\Intrasys.Helutrans.AMS.Api3\Code\Database\Data\Models" -ignoreText "Instant"
```
Remove the following regions under Authorization - AccountType, ApiKey, Country, CountryZone, Language, Location, Log, LogType, Permission, PermissionSet, Role, RoleClaim, Tenant, TenantType, Timezone, User, UserClaim, UserLogin, UserToken.
