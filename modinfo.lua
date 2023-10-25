local isEN = locale~="zh" and locale~="zhr"    --如果当前语言环境不是中文
name = isEN and "Joint ban" or "联合封禁"
author = "雨夏"
version = "1.1"
description = isEN and "[Version]\n    "..version..[[

[Introduction to the Mod]
    Automatically ban the Griefers that other people reported.
	https://github.com/ylk2534246654/dst-mod-joint-ban/issues

]] or "[当前版本]\n    "..version..[[

[模组介绍]
    自动封禁其他玩家提供的捣乱者信息。

	需要提供捣乱者信息可在讨论页面留言或前往
	https://github.com/ylk2534246654/dst-mod-joint-ban/issues

]]

forumthread = ""     --和官方论坛相关，一般不填

api_version =  10                   --api 版本，联机版目前为 10，如果不填 10，则会被提示模组已经过期。
dont_starve_compatible = false      --兼容饥荒单机版
reign_of_giants_compatible = false  --兼容饥荒巨人版
dst_compatible = true               --此值为 true 则表明模组兼容联机版
all_clients_require_mod = false     --让客机知道自己是否需要订阅这个模组并下载下来，通常有自定义美术资源的，都需要令此项为 true。
client_only_mod = false             --这一项和上一项正好相反，如果此项为 true，则这是一个客机模组，可以在游戏模组界面启动。否则需要在开启房间的界面启动。

icon_atlas = "modicon.xml"  --mod图标
icon = "modicon.tex"

server_filter_tags = {  --服务器标签
    name,
}

local function AddTitle(title)
    return {
        label = title,
        name = "",
        hover = "",
        options = {{description = "", data = 0}},
        default = 0
    }
end

configuration_options = {
	-- {
	-- 	name = "language",
    --     hover = isEN and "Choose your language" or "选择您使用的语言",
    --     label = isEN and "Language" or "语言",
	-- 	options =		
	-- 		{
	-- 			{description = "Auto", data = "auto", hover = isEN and "Detect the language based on language mods installed." or "根据安装的语言模块检测语言。"},
	-- 			{description = "English", data = "english", hover = isEN and "English" or "英语"},     --英语
	-- 			{description = "中文(简体)", data = "chinese_s", hover = isEN and "Simplified Chinese" or "简体中文"},
	-- 			{description = "中文(繁体)", data = "chinese_t", hover = isEN and "Traditional Chinese" or "繁体中文"},
	-- 			{description = "日本語", data = "japanese", hover = isEN and "Japanese" or "日语"},    --日语
	-- 			{description = "русский", data = "russian", hover = isEN and "Russian" or "俄语"},     --俄语
	-- 			{description = "Deutsch", data = "german", hover = isEN and "German" or "德语"},       --德语
	-- 			{description = "Português (BR)", data = "portuguese", hover = isEN and "Portuguese BR" or "葡萄牙语"}, --葡萄牙语
	-- 			{description = "Español", data = "spanish", hover = isEN and "Spanish" or "西班牙语"},     --西班牙语
	-- 			{description = "Polish", data = "polish", hover = isEN and "Polish" or "波兰语"},       --波兰语
	-- 			{description = "Czech", data = "czech", hover = isEN and "Czech" or "捷克语"},           --捷克语
	-- 			{description = "ภาษาไทย", data = "thai", hover = isEN and "Thai" or "泰语"},            --泰语
	-- 		},
	-- 	default = "auto",
	-- },
}