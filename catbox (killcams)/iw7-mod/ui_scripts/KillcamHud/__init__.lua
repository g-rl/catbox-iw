--[[
TODO:
	- Show player weapon icon
		- check for MKII and MKI variants
			- Show watermark
	- Create container for player perks
		- Show player perk icons
	-
]]

if not Engine.IsAliensMode() or Engine.InFrontend() then
	return
end

if CONDITIONS.IsThirdGameMode then
	function IsPublicMatch( self ) -- allow rank to be shown on playercard, disable for now.
		return false
	end
end

killcam = {}
killcam.qualities = {
	{
		color = COLORS.grey102,
		image = "icon_item_quality_0"
	},
	{
		color = COLORS.lightGrey,
		image = "icon_item_quality_1"
	},
	{
		color = COLORS.cobaltBlue,
		image = "icon_item_quality_2"
	},
	{
		color = COLORS.fullPurple,
		image = "icon_item_quality_3"
	},
	{
		color = COLORS.epicOrange,
		image = "icon_item_quality_4"
	}
}

function SpectatingStub(menu, controller)
    local self = LUI.UIElement.new()
	self:SetAnchorsAndPosition( 0, 1, 0, 1, 0, 1200 * _1080p, 0, 145 * _1080p )
	self.id = "KillcamHud"
	local clientnum = controller and controller.controllerIndex
	if not clientnum and not Engine.InFrontend() then
		clientnum = self:getRootController()
	end

    -- header
    local Overlay = nil
	Overlay = LUI.UIImage.new()
    Overlay:SetAnchorsAndPosition( 0, 0, 0, 1, _1080p * -500, _1080p * 500, _1080p * -500, _1080p * -355 )
	Overlay.id = "Overlay"
	Overlay:SetRGBFromTable( SWATCHES.killcam.topHeader, 0 )
	Overlay:SetUseAA( true )
	Overlay:SetBlendMode( BLEND_MODE.multiply )
    self:addElement(Overlay)
	self.Overlay = Overlay

	local Text = nil
	Text = LUI.UIStyledText.new()
	Text.id = "Text"
	Text:setText( Engine.Localize( "LUA_MENU_KILLCAM_CAPS" ) )
	Text:SetFontSize( 48 * _1080p )
	Text:SetFont( FONTS.GetFont( FONTS.MainBold.File ) )
	Text:SetAlignment( LUI.Alignment.Center )
	Text:SetAnchorsAndPosition( 0, 0, 1, 0, 0, 0, _1080p * -570, _1080p * -525 )
	self:addElement( Text )
	self.Text = Text
    
    -- footer
    local Footer = nil
	Footer = LUI.UIImage.new()
    Footer:SetAnchorsAndPosition( 0, 0, 0, 1, _1080p * -500, _1080p * 500, _1080p * 480, _1080p * 575 )
	Footer.id = "Footer"
	Footer:SetRGBFromInt( 1973790, 0 )
	Footer:SetAlpha( 0.45, 0 )
	Footer:SetUseAA( true )
    self:addElement(Footer)
	self.Footer = Footer

	-- playercard
	local PlayerCard = nil
	PlayerCard = MenuBuilder.BuildRegisteredType( "SmallPlayerCard", {
		controllerIndex = clientnum
	} )
	PlayerCard.id = "PlayerCard"
	PlayerCard:SetScale( 0.05, 0 )
	PlayerCard:SetDataSource( DataSources.inGame.MP.spectating.playerCard, clientnum )
	PlayerCard:SetAnchorsAndPosition( 0, 1, 0, 1, _1080p * 182, _1080p * 600,  _1080p * 480, _1080p * 573 )
	PlayerCard.BackgroundFill:SetAnchorsAndPosition( 0, 1, 0, 0, _1080p * 1, _1080p * 119.19, _1080p * 1, _1080p * -1 )
	self:addElement( PlayerCard )
	self.PlayerCard = PlayerCard
	
	-- Killed by info
	local VictimName = nil
	VictimName = LUI.UIStyledText.new()
	VictimName.id = "VictimName"
	VictimName:SetAlpha( 1, 0 )
	VictimName:setText( LocalizeIntoString( Engine.GetDvarString("zombie_archtype"), "CGAME_VICTIM" ), 0 )
	VictimName:SetFontSize( 26 * _1080p )
	VictimName:SetFont( FONTS.GetFont( FONTS.MainBold.File ) )
	VictimName:SetAlignment( LUI.Alignment.Left )
	VictimName:SetShadowMinDistance( -0.2, 0 )
	VictimName:SetShadowMaxDistance( 0.2, 0 )
	VictimName:SetShadowRGBFromInt( 0, 0 )
	VictimName:SetAnchorsAndPosition( 0, 1, 0, 1, _1080p * 175, _1080p * 695, _1080p * 425, _1080p * 445 )
	self:addElement( VictimName )
	self.VictimName = VictimName
	
	local killerName = nil
	killerName = LUI.UIStyledText.new()
	killerName.id = "VictimName"
	killerName:SetAlpha( 1, 0 )
	killerName:setText( "Killed By: " .. self.PlayerCard:GetDataSource().fullName:GetValue( clientnum ), 0 )
	killerName:SetFontSize( 26 * _1080p )
	killerName:SetFont( FONTS.GetFont( FONTS.MainBold.File ) )
	killerName:SetAlignment( LUI.Alignment.Left )
	killerName:SetShadowMinDistance( -0.2, 0 )
	killerName:SetShadowMaxDistance( 0.2, 0 )
	killerName:SetShadowRGBFromInt( 0, 0 )
	killerName:SetAnchorsAndPosition( 0, 1, 0, 1, _1080p * 175, _1080p * 695, _1080p * 450, _1080p * 470 )
	self:addElement( killerName )
	self.killerName = killerName

	HitMarker = MenuBuilder.BuildRegisteredType( "HitMarker", {
		controllerIndex = clientnum
	} )
	HitMarker.id = "HitMarker"
	HitMarker:SetAnchors( 0.5, 0.5, 0.5, 0.5, 0 )
	HitMarker:SetLeft( _1080p * -11, 0 )
	HitMarker:SetRight( _1080p * 11, 0 )
	HitMarker:SetTop( _1080p * -11, 0 )
	HitMarker:SetBottom( _1080p * 11, 0 )
	HitMarker:setPriority( -2 )
	self:addElement( HitMarker )
	self.HitMarker = HitMarker
	
	local HitMarkerIcon = MenuBuilder.BuildRegisteredType( "HitMarkerIcon", {
		controllerIndex = clientnum
	} )
	HitMarkerIcon.id = "HitMarkerIcon"
	HitMarkerIcon:SetAnchors( 0.5, 0.5, 0.5, 0.5, 0 )
	HitMarkerIcon:SetLeft( _1080p * 16, 0 )
	HitMarkerIcon:SetRight( _1080p * 64, 0 )
	HitMarkerIcon:SetTop( _1080p * 11, 0 )
	HitMarkerIcon:SetBottom( _1080p * 59, 0 )
	HitMarkerIcon:setPriority( -2 )
	self:addElement( HitMarkerIcon )
	self.HitMarkerIcon = HitMarkerIcon

	local LootColorFillWeaponText = nil
	LootColorFillWeaponText = LUI.UIImage.new()
	LootColorFillWeaponText.id = "LootColorFillWeaponText"
	LootColorFillWeaponText:SetAlpha( 0.5, 0 )
	LootColorFillWeaponText:SetAnchorsAndPosition( 0.5, 0.5, 0, 0, _1080p * -326, _1080p * 267, 320, 285 )
	LootColorFillWeaponText:SetRGBFromTable( killcam.qualities[(Engine.GetDvarInt("ui_killcam_weaponvariantid") or 0) + 1].color, 0 )
	self:addElement( LootColorFillWeaponText )
	self.LootColorFillWeaponText = LootColorFillWeaponText
	
	local LootColorBarRight = nil
	LootColorBarRight = LUI.UIImage.new()
	LootColorBarRight.id = "LootColorBarRight"
	LootColorBarRight:SetAnchorsAndPosition( 0.5, 0.5, 0, 0, _1080p * 271, _1080p * 279, 320, 285 )
	LootColorBarRight:SetRGBFromTable( killcam.qualities[(Engine.GetDvarInt("ui_killcam_weaponvariantid") or 0) + 1].color, 0 )
	LootColorBarRight:SetAlpha( 0.45, 0 )
	LootColorBarRight:SetUseAA( true )
	self:addElement( LootColorBarRight )
	self.LootColorBarRight = LootColorBarRight
	
	local LootColorBarleft = nil
	LootColorBarleft = LUI.UIImage.new()
	LootColorBarleft.id = "LootColorBarleft"
	LootColorBarleft:SetAnchorsAndPosition( 0.5, 0.5, 0, 0, _1080p * -331, _1080p * -339, 320, 285 )
	LootColorBarleft:SetRGBFromTable( killcam.qualities[(Engine.GetDvarInt("ui_killcam_weaponvariantid") or 0) + 1].color, 0 )
	LootColorBarleft:SetAlpha( 0.45, 0 )
	LootColorBarleft:SetUseAA( true )
	self:addElement( LootColorBarleft )
	self.LootColorBarleft = LootColorBarleft

	local WeaponIcon = nil
	WeaponIcon = LUI.UIImage.new()
	WeaponIcon.id = "WeaponIcon"							-- 150                            -- 75
	WeaponIcon:SetAnchorsAndPosition( 0.5, 0.5, 0.5, 0.5, _1080p * 100, _1080p * 250, _1080p * 422, _1080p * 497, 0 )
	WeaponIcon:setImage( RegisterMaterial( Engine.GetDvarString("ui_killcam_weaponicon") ) )
	self:addElement( WeaponIcon )
	self.WeaponIcon = WeaponIcon

	local WeaponText = nil
	WeaponText = LUI.UIStyledText.new()
	WeaponText.id = "WeaponText"
	WeaponText:setText( Engine.Localize( Engine.GetDvarString("ui_killcam_weaponname") ), 0 )
	WeaponText:SetFontSize( 48 * _1080p )
	WeaponText:SetFont( FONTS.GetFont( FONTS.MainBold.File ) )
	WeaponText:SetAlignment( LUI.Alignment.Left )			-- -332                    -- 24
	WeaponText:SetAnchorsAndPosition( 0.5, 0.5, 0, 1, _1080p * -314, _1080p * 0, _1080p * 485, _1080p * 509 )
	self:addElement( WeaponText )
	self.WeaponText = WeaponText
	
	local MK2 = nil
	MK2 = LUI.UIImage.new()
	MK2.id = "MK2"
	if Engine.GetDvarInt("ui_killcam_weaponmk2") == 1 then
		MK2:SetAlpha( 0.5, 0 )
	else
		MK2:SetAlpha( 0, 0 )
	end
	MK2:setImage( RegisterMaterial( "mk2_watermark_1" ) )
	MK2:SetBlendMode( BLEND_MODE.addWithAlpha ) -- 64                          -- 32
	MK2:SetAnchorsAndPosition( 0, 1, 0, 1, _1080p * 700, _1080p * 764, _1080p * 527, _1080p * 559 )
	self:addElement( MK2 )
	self.MK2 = MK2

	local weaponLootRarityIcon = nil
	weaponLootRarityIcon = LUI.UIImage.new()
	weaponLootRarityIcon.id = "weaponLootRarityIcon"					 -- 45                         -- 45
	weaponLootRarityIcon:SetAnchorsAndPosition( 0.5, 0.5, 1, 0, _1080p * -320, _1080p * -275, _1080p * 375, _1080p * 420 )
	weaponLootRarityIcon:setImage( RegisterMaterial( killcam.qualities[(Engine.GetDvarInt("ui_killcam_weaponvariantid") or 0) + 1].image ) )
	weaponLootRarityIcon:SetRGBFromTable( killcam.qualities[(Engine.GetDvarInt("ui_killcam_weaponvariantid") or 0) + 1].color, 0 )
	weaponLootRarityIcon:SetAlpha( 1, 0 )
	weaponLootRarityIcon:SetUseAA( true )
	self:addElement( weaponLootRarityIcon )
	self.weaponLootRarityIcon = weaponLootRarityIcon

	local PerksText = nil
	PerksText = LUI.UIStyledText.new()
	PerksText.id = "PerksText"
	PerksText:setText( "Perks", 0 )
	PerksText:SetFontSize( 48 * _1080p )
	PerksText:SetFont( FONTS.GetFont( FONTS.MainBold.File ) )
	PerksText:SetAlignment( LUI.Alignment.Left )			-- -332                    -- 24
	PerksText:SetAnchorsAndPosition( 0.5, 0.5, 0, 1, _1080p * 295, _1080p * 0, _1080p * 485, _1080p * 509 )
	self:addElement( PerksText )
	self.PerksText = PerksText

	local PerkList = nil
	PerkList = LUI.UIDataSourceToggleList.new( nil, {
		listDataSource = DataSources.inGame.CP.zombies.perks.activePerks,
		controlDataSource = DataSources.inGame.CP.zombies.perks.activePerkBits,
		buildChild = function ()
			return MenuBuilder.BuildRegisteredType( "CPPerkIcon", {
				controllerIndex = clientnum
			} )
		end,
		controller = clientnum,
		orderedIndices = false,
		direction = LUI.DIRECTION.horizontal,
		horizontalAlignment = LUI.Alignment.Left,
		verticalAlignment = LUI.Alignment.None,
	} )
	PerkList.id = "PerkList"
	PerkList:SetAnchorsAndPosition( 1, 0, 1, 0, _1080p * -580, 0, _1080p * 375, _1080p * -300 )
	self:addElement( PerkList )
	self.PerkList = PerkList
	
    return self
end

MenuBuilder.m_types["Spectating"] = SpectatingStub