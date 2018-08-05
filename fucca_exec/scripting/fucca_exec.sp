#include <sourcemod>

public Plugin myinfo = 
{
	name = "exec",
	author = "뿌까",
	description = "하하하하",
	version = "2.0",
	url = "x"
};

new Handle:CvarUGC = INVALID_HANDLE, Handle:map;
new String:g_strugc[64], String:match[120];

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	// LoadTranslations("basevotes.phrases");
	
	BuildPath(Path_SM, match, sizeof(match), "configs/match.cfg");
	
	CvarUGC = CreateConVar("ugc", "66", "66 99");
	GetConVarString(CvarUGC, g_strugc, sizeof(g_strugc));
	HookConVarChange(CvarUGC, ConVarChanged);
	
	// RegConsoleCmd("sm_ugc", pug);
	
	map = CreateArray(120);
}

public OnMapEnd()
{
	if(map != INVALID_HANDLE) CloseHandle(map);
}

public OnConfigsExecuted()
{	
	new Handle:hl = CreateKeyValues("99");
	FileToKeyValues(hl, match);
	
	decl String:file[120];
	
	KvGetString(hl, "99_cp", file, sizeof(file));
	PushArrayString(map, file);
		
	KvGetString(hl, "99_pl", file, sizeof(file));
	PushArrayString(map, file);
		
	KvGetString(hl, "99_koth", file, sizeof(file));
	PushArrayString(map, file);
	
	KvGetString(hl, "66_cp", file, sizeof(file));
	PushArrayString(map, file);
		
	KvGetString(hl, "66_pl", file, sizeof(file));
	PushArrayString(map, file);
		
	KvGetString(hl, "66_koth", file, sizeof(file));
	PushArrayString(map, file);
	
	CloseHandle(hl);

	SetConVarInt(FindConVar("sm_chat_mode"),0);
	
	GetConVarString(CvarUGC, g_strugc, sizeof(g_strugc));
	SetConfig(g_strugc);
}

public ConVarChanged(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if(StrEqual(newVal, "66")) SetConfig("66");
	else if(StrEqual(newVal, "99")) SetConfig("99");
	else if(StrEqual(newVal, "ulti")) SetConfig("ulti");
}

stock SetConfig(String:ugc[])
{
	new String:config[120];
	if(StrEqual(ugc, "99"))
	{
		if(IsCpMap())
		{
			GetArrayString(map, 0, config, sizeof(config));
			ServerCommand("exec %s", config);
		}
		else if(IsPlMap())
		{
			GetArrayString(map, 1, config, sizeof(config));
			ServerCommand("exec %s", config);
		}
		else if(IsKothMap())
		{
			GetArrayString(map, 2, config, sizeof(config));
			ServerCommand("exec %s", config);
		}
	}
	else if(StrEqual(ugc, "66"))
	{
		if(IsCpMap())
		{
			GetArrayString(map, 3, config, sizeof(config));
			ServerCommand("exec %s", config);
		}
		else if(IsPlMap())
		{
			GetArrayString(map, 4, config, sizeof(config));
			ServerCommand("exec %s", config);
		}
		else if(IsKothMap())
		{
			GetArrayString(map, 5, config, sizeof(config));
			ServerCommand("exec %s", config);
		}
	}
	else if(StrEqual(ugc, "ulti")) ServerCommand("exec tfcl_ultiduo_standard");
	SetConVarString(CvarUGC, ugc);
}

stock bool:IsCpMap2()
{
	decl String:strMap[64];
	GetCurrentMap(strMap, sizeof(strMap));
	return StrContains(strMap, "cp_", false) == 0;
}

stock bool:IsCpMap()
{
	decl String:strMap[64];
	GetCurrentMap(strMap, sizeof(strMap));
	return StrContains(strMap, "cp_", false) == 0;
}

stock bool:IsPlMap()
{
	decl String:strMap[64];
	GetCurrentMap(strMap, sizeof(strMap));
	return StrContains(strMap, "pl_", false) == 0;
}

stock bool:IsKothMap()
{
	decl String:strMap[64];
	GetCurrentMap(strMap, sizeof(strMap));
	return StrContains(strMap, "koth_", false) == 0;
}