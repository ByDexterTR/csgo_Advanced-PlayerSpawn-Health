#include <sourcemod>
#undef REQUIRE_PLUGIN
#include <warden>

#pragma semicolon 1
#pragma newdecls required

ConVar g_Warden_health = null, g_CT_health = null, g_T_health = null, g_Admin_health = null;

bool bWarden;

public Plugin myinfo = 
{
	name = "Advanced Player Spawn Health", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	HookEvent("player_spawn", OnClientSpawn);
	g_Warden_health = CreateConVar("sm_warden_health", "200", "Warden health", FCVAR_NOTIFY, true, 1.0);
	g_Admin_health = CreateConVar("sm_admin_health", "150", "Admin health", FCVAR_NOTIFY, true, 1.0);
	g_CT_health = CreateConVar("sm_ct_health", "120", "CT health", FCVAR_NOTIFY, true, 1.0);
	g_T_health = CreateConVar("sm_t_health", "120", "T health", FCVAR_NOTIFY, true, 1.0);
	AutoExecConfig(true, "PlayerSpawn-Health", "ByDexter");
	
	bWarden = LibraryExists("warden");
}

public void OnLibraryAdded(const char[] name)
{
	if (strcmp(name, "warden") == 0)
	{
		bWarden = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (strcmp(name, "warden") == 0)
	{
		bWarden = false;
	}
}

public Action OnClientSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientUserId(event.GetInt("userid"));
	if (!IsFakeClient(client))
	{
		if (GetClientTeam(client) == 3)
			SetEntityHealth(client, g_CT_health.IntValue);
		
		if (GetClientTeam(client) == 2)
			SetEntityHealth(client, g_T_health.IntValue);
		
		if (GetUserAdmin(client) != INVALID_ADMIN_ID)
			SetEntityHealth(client, g_Admin_health.IntValue);
		
		if (bWarden && warden_iswarden(client))
			SetEntityHealth(client, g_Warden_health.IntValue);
	}
} 