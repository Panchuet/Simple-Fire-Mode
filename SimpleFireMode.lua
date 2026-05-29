behaviour("SimpleFireMode")

-- Keys:
--   startSemi             (bool)   : If true, the weapon starts in semi-auto instead of full-auto
--   switchCooldown        (float)  : Lockout time in seconds before you can switch modes again, best if you match the switch animation length
--   switchKeybind         (string) : Lowercase keybind of the key you want to use to switch modes
--   switchParameterName   (string) : Name of the animator trigger parameter to play on switch
--   selectorValues        (string) : Two space-separated integers for the selector lever position per mode e.g. "0 1" (mode 0 = auto, mode 1 = semi)
--   selectorParameterName (string) : Name of the animator integer parameter that holds the selector lever position

function SimpleFireMode:Start()
    self.weapon = self.gameObject.GetComponent(Weapon)
    self.animator = self.gameObject.GetComponent(Animator)
    self.dataContainer = self.gameObject.GetComponent(DataContainer)

    self.modeIndex = self.dataContainer.GetBool("startSemi") and 1 or 0
    self.switchCooldown = self.dataContainer.GetFloat("switchCooldown")
    self.switchKeybind = self.dataContainer.GetString("switchKeybind")

    self.selectorValues = {}
    for match in (self.dataContainer.GetString("selectorValues") .. " "):gmatch("(.-) ") do
        table.insert(self.selectorValues, tonumber(match))
    end
    
    if self.animator ~= nil then
        self.switchParameter = self.animator.StringToHash(self.dataContainer.GetString("switchParameterName"))
        self.selectorParameter = self.animator.StringToHash(self.dataContainer.GetString("selectorParameterName"))
    end

    self.switchTimer = 0
    self:ApplyMode()
end

function SimpleFireMode:ApplyMode()
    self.weapon.isAuto = self.modeIndex == 0
    
    if self.animator ~= nil then
        self.animator.SetInteger(self.selectorParameter, self.selectorValues[self.modeIndex + 1])
    end
end

function SimpleFireMode:SwitchMode()
    self.modeIndex = 1 - self.modeIndex
    self.switchTimer = self.switchCooldown
    self.weapon.LockWeapon()
    
    if self.animator ~= nil then
        self.animator.SetTrigger(self.switchParameter)
    end
    
    self:ApplyMode()
end

function SimpleFireMode:OnEnable()
    if self.animator == nil then return end
    self.animator.SetInteger(self.selectorParameter, self.selectorValues[self.modeIndex + 1])
end

function SimpleFireMode:Update()
    if self.weapon == nil then return end

    if self.switchTimer > 0 then
        self.switchTimer = self.switchTimer - Time.deltaTime

        if self.switchTimer <= 0 then
            self.weapon.UnlockWeapon()
        end
    end

    if self.switchTimer <= 0
        and not self.weapon.isReloading
        and self.weapon.user ~= nil
        and self.weapon.user.isPlayer
        and Input.GetKeyDown(self.switchKeybind)
    then
        self:SwitchMode()
    end
end