local v1 = {};
local l__Players__2 = game:GetService("Players");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__Remotes__4 = l__ReplicatedStorage__3:WaitForChild("Remotes");
local l__Modules__5 = game.ReplicatedStorage:WaitForChild("Modules");
local l__SFX__6 = l__ReplicatedStorage__3:WaitForChild("SFX");
local l__LocalPlayer__7 = l__Players__2.LocalPlayer;
local v8 = l__ReplicatedStorage__3:WaitForChild("Players"):WaitForChild(l__LocalPlayer__7.Name);
local v9 = { "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "RightUpperLeg", "UpperTorso", "Head", "FaceHitBox", "HeadTopHitBox" };
local function u1(p1, p2)
	local v10 = p1.Origin - p2;
	local l__Direction__11 = p1.Direction;
	return p2 + (v10 - v10:Dot(l__Direction__11) / l__Direction__11:Dot(l__Direction__11) * l__Direction__11);
end;
local l__RangedWeapons__2 = l__ReplicatedStorage__3:WaitForChild("RangedWeapons");
local u3 = require(game.ReplicatedStorage.Modules:WaitForChild("FunctionLibraryExtension"));
local l__VFX__4 = game.ReplicatedStorage:WaitForChild("VFX");
local l__Debris__5 = game:GetService("Debris");
local function u6(p3, p4)
	local v12 = nil;
	local v13 = nil;
	local v14 = nil;
	local v15 = nil;
	local l__Keypoints__16 = p3.Keypoints;
	for v17 = 1, #l__Keypoints__16 do
		if v17 == 1 then
			v12 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		elseif v17 == 2 then
			v13 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		elseif v17 == 3 then
			v14 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		elseif v17 == 4 then
			v15 = NumberSequenceKeypoint.new(l__Keypoints__16[v17].Time, l__Keypoints__16[v17].Value * p4);
		end;
	end;
	return NumberSequence.new({ v12, v13, v14, v15 });
end;
local u7 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables")).ReturnTable("GlobalIgnoreListProjectile");
local l__FireProjectile__8 = game.ReplicatedStorage.Remotes.FireProjectile;
local u9 = require(game.ReplicatedStorage.Modules:WaitForChild("VFX"));
local function u10(p5, p6, p7)
	local l__p__18 = p5.CFrame.p;
	local v19 = Vector3.new(l__p__18.X, l__p__18.Y + 1.6, l__p__18.Z);
	return u1(Ray.new(v19, (p7 - v19).unit * 7500), p6).Y;
end;
local l__ProjectileInflict__11 = game.ReplicatedStorage.Remotes.ProjectileInflict;
function v1.CreateBullet(p8, p9, p10, p11, p12, p13, p14, p15)
	print("new called!", p11)
	local l__Character__20 = l__LocalPlayer__7.Character;
	local l__HumanoidRootPart__21 = l__Character__20.HumanoidRootPart;
	if l__Character__20:FindFirstChild(p9.Name) then
		local v22 = nil;
		local v23 = nil;
		if p11.Item.Attachments:FindFirstChild("Front") then
			v22 = p11.Item.Attachments.Front:GetChildren()[1].Barrel;
			v23 = p10.Attachments.Front:GetChildren()[1].Barrel;
		else
			v22 = p11.Item.Barrel;
			v23 = p10.Barrel;
		end;
		local l__ItemRoot__24 = p10.ItemRoot;
		local v25 = l__RangedWeapons__2:FindFirstChild(p9.Name);
		local v26 = l__ReplicatedStorage__3.AmmoTypes:FindFirstChild(p13);
		local v27 = v25:GetAttribute("ProjectileColor");
		local v28 = v25:GetAttribute("BulletMaterial");
		local v29 = v26:GetAttribute("ProjectileDrop");
		local v30 = v26:GetAttribute("MuzzleVelocity");
		local v31 = v25:GetAttribute("RecoilRecoveryTimeMod");
		local v32 = v26:GetAttribute("Shotgun");
		local v33 = v26:GetAttribute("Damage");
		local v34 = v26:GetAttribute("Arrow");
		local v35 = v26:GetAttribute("ProjectileWidth");
		local v36 = nil;
		if p15 and v25:FindFirstChild("RecoilPattern") then
			local v37 = #v25.RecoilPattern:GetChildren();
			v36 = v25.RecoilPattern:FindFirstChild(tostring(p15));
		end;
		local v38 = p9.ItemProperties.Tool:GetAttribute("MuzzleDevice") and "Default" or "Default";
		local v39 = v26:GetAttribute("RecoilStrength");
		local v40 = v39;
		local v41 = v39;
		local l__Attachments__42 = p9:FindFirstChild("Attachments");
		if l__Attachments__42 then
			local v43 = l__Attachments__42:GetChildren();
			for v44 = 1, #v43 do
				local v45 = v43[v44]:FindFirstChildOfClass("StringValue");
				if v45 and v45.ItemProperties:FindFirstChild("Attachment") then
					local l__Attachment__46 = v45.ItemProperties.Attachment;
					local v47 = l__Attachment__46:GetAttribute("Recoil");
					if v47 then
						v40 = v40 + v47 * l__Attachment__46:GetAttribute("HRecoilMod");
						v41 = v41 + v47 * l__Attachment__46:GetAttribute("VRecoilMod");
					end;
					local v48 = l__Attachment__46:GetAttribute("MuzzleDevice");
					if v48 then
						v38 = v48;
						if p11.Item.Attachments.Muzzle:FindFirstChild(v45.Name):FindFirstChild("BarrelExtension") then
							v23 = p11.Item.Attachments.Muzzle:FindFirstChild(v45.Name):FindFirstChild("BarrelExtension");
						end;
					end;
				end;
			end;
		end;
		if v38 == "Suppressor" then
			if tick() - p14 < 0.8 then
				u3:PlaySoundV2(l__ItemRoot__24.FireSoundSupressed, l__ItemRoot__24.FireSoundSupressed.TimeLength, l__HumanoidRootPart__21, l__ItemRoot__24.FireSoundSupressed.Volume * 1);
			else
				u3:PlaySoundV2(l__ItemRoot__24.FireSoundSupressed, l__ItemRoot__24.FireSoundSupressed.TimeLength, l__HumanoidRootPart__21, 1.7);
			end;
		elseif tick() - p14 < 0.8 then
			u3:PlaySoundV2(l__ItemRoot__24.FireSound, l__ItemRoot__24.FireSound.TimeLength, l__HumanoidRootPart__21, l__ItemRoot__24.FireSound.Volume * 1);
		else
			u3:PlaySoundV2(l__ItemRoot__24.FireSound, l__ItemRoot__24.FireSound.TimeLength, l__HumanoidRootPart__21, 1.7);
		end;
		if v25:GetAttribute("MuzzleEffect") == true and v23:FindFirstChild("MuzzleLight") then
			local v49 = l__VFX__4.MuzzleEffects:FindFirstChild(v38):GetChildren();
			local v50 = v23.MuzzleLight:Clone();
			v50.Enabled = true;
			l__Debris__5:AddItem(v50, 0.1);
			v50.Parent = v22;
			local v51 = v49[math.random(1, #v49)]:GetChildren();
			for v52 = 1, #v51 do
				if v51[v52].className == "ParticleEmitter" then
					local v53 = 1;
					local v54 = v51[v52]:Clone();
					v54.Parent = v22;
					local v55 = math.clamp(v33 / 45 / 2.5, 0, 0.6);
					if v32 then
						v55 = math.clamp(v33 * v32.Value / 45 / 2.5, 0, 0.6);
					end;
					v54.Lifetime = NumberRange.new(v54.Lifetime.Max * v55);
					v54.Size = u6(v54.Size, v55);
					if v54:FindFirstChild("EmitCount") then
						v53 = v54.EmitCount.Value;
					end;
					delay(0.01, function()
						v54:Emit(v53);
						l__Debris__5:AddItem(v54, v54.Lifetime.Max);
					end);
				end;
			end;
		end;
		local u12 = 0;
		local u13 = "";
		local l__CurrentCamera__14 = workspace.CurrentCamera;
		local u15 = v30 / 2700;
		local function v56()
			u12 = u12 + 1;
			local v57 = RaycastParams.new();
			v57.FilterType = Enum.RaycastFilterType.Blacklist;
			local v58 = { l__Character__20, p11, u7 };
			v57.FilterDescendantsInstances = v58;
			v57.IgnoreWater = false;
			v57.CollisionGroup = "WeaponRay";
			local v59 = tick();
			local l__p__60 = l__HumanoidRootPart__21.CFrame.p;
			local l__LookVector__61 = v22.CFrame.LookVector;
			local v62 = Vector3.new(l__p__60.X, l__p__60.Y + 1.6, l__p__60.Z);
			local v63 = v62 + l__LookVector__61 * 1000 + Vector3.new(math.random(0, 0), math.random(0, 0), math.random(0, 0));
            if getfenv().currentCanidateSA then
                v63 = getfenv().currentCanidateSA.Position
            end
			if v32 == nil then

			end;
			if u12 == 1 and v32 ~= nil or v32 == nil then
				u13 = v63.Y .. "posY" .. game.Players.LocalPlayer.UserId .. "Id" .. tick();
				l__FireProjectile__8:FireServer(v63, u13, false, {});
			elseif u12 > 1 and v32 ~= nil and u12 < v32.Value - 2 then
				l__FireProjectile__8:FireServer(v63, u13, true, {});
			end;
			local v64 = l__VFX__4.MuzzleEffects.Tracer:Clone();
			v64.Name = u13;
			v64.Color = v27;
			l__Debris__5:AddItem(v64, 6);
			v64.Position = Vector3.new(0, -100, 0);
			v64.Parent = game.Workspace.NoCollision.Effects;
			local u16 = nil;
			local u17 = 0;
			local u18 = v62;
			local u19 = getfenv().currentCanidateSA ~= nil and CFrame.new(v62, v63).LookVector or l__LookVector__61;--l__LookVector__61;
			local u20 = 0;
			local u21 = {};
			local u22 = false;
			local function u23()
				v64:Destroy();
				u16:Disconnect();
			end;
			u16 = game:GetService("RunService").Heartbeat:Connect(function(p16)
				u17 = u17 + p16;
				if u17 > 0.008333333333333333 then
					local v65 = v30 * u17;
					local v66 = workspace:Raycast(u18, u19 * v65, v57);
					local v67 = nil;
					local v68 = nil;
					local v69 = Vector3.new()
					if v66 then
						v67 = v66.Instance;
						v69 = v66.Position;
						v68 = v66.Normal;
					else
						v69 = u18 + u19 * v65;
					end;
					local l__magnitude__70 = (u18 - v69).magnitude;
					u20 = u20 + l__magnitude__70;
					if u20 > 100 then
						local v71 = math.clamp((l__CurrentCamera__14.CFrame.Position - v69).magnitude / 90, 0.4 * u15, 1.2 * u15);
						v64.Size = Vector3.new(v71, v71, l__magnitude__70);
						v64.CFrame = CFrame.new(u18, v69) * CFrame.new(0, 0, -l__magnitude__70 / 2);
					end;
					if v67 then
						table.insert(u21, {
							stepAmount = u17, 
							dropTiming = 0
						});
						local v72 = u3:FindDeepAncestor(v67, "Model");
						if v67:GetAttribute("PassThrough", 2) then
							table.insert(v58, v67);
							v57.FilterDescendantsInstances = v58;
							return;
						end;
						if v67:GetAttribute("PassThrough", 1) and v34 == nil then
							table.insert(v58, v67);
							v57.FilterDescendantsInstances = v58;
							return;
						end;
						if v67:GetAttribute("Glass") then
							u9.Impact(v67, v69, v68, u19, "Ranged", true);
							table.insert(v58, v67);
							v57.FilterDescendantsInstances = v58;
							return;
						end;
						if v67.Name ~= "Terrain" then
							if v72:FindFirstChild("Humanoid") then
								if v34 ~= nil then
									(nil):FireServer(v72, v67, u13, v69, u10(l__HumanoidRootPart__21, v69, v63));
								end;
								l__ProjectileInflict__11:FireServer(v72, v67, u13, u21, v69, u10(l__HumanoidRootPart__21, v69, v63), v67.Position.X - v69.X, v67.Position.Z - v69.Z);
								u9.Impact(v67, v69, v68, u19, "Ranged", true);
								u23();
								return;
							else
								if v34 ~= nil then
									(nil):FireServer(v67.Parent, v67, u13, v69, u10(l__HumanoidRootPart__21, v69, v63));
								end;
								if v72.ClassName == "Model" and v72.PrimaryPart ~= nil and v72.PrimaryPart:GetAttribute("Health") then
									l__ProjectileInflict__11:FireServer(v72, v67, u13, u21, v69, u10(l__HumanoidRootPart__21, v69, v63), v67.Position.X - v69.X, v67.Position.Z - v69.Z);
									if v72.Parent.Name ~= "SleepingPlayers" and v68 then
										u9.Impact(v67, v69, v68, u19, "Ranged", true);
									end;
								else
									u9.Impact(v67, v69, v68, u19, "Ranged", true);
								end;
								u23();
								return;
							end;
						end;
						local v73 = false;
						if u22 == false then
							local v74 = game.Workspace.Terrain:ReadVoxels(Region3.new(Vector3.new(v69.X - 2, v69.Y - 2, v69.Z - 2), Vector3.new(v69.X + 2, v69.Y + 2, v69.Z + 2)):ExpandToGrid(4), 4);
							local l__Size__75 = v74.Size;
							for v76 = 1, l__Size__75.X do
								if v73 == true then
									break;
								end;
								for v77 = 1, l__Size__75.Y do
									if v73 == true then
										break;
									end;
									for v78 = 1, l__Size__75.Z do
										if v73 == true then
											break;
										end;
										if v74[v76][v77][v78] == Enum.Material.Water then
											u22 = true;
											v57.IgnoreWater = true;
											u9.Impact(v67, v69, v68, u19, "Ranged");
											v73 = true;
										end;
									end;
								end;
							end;
						end;
						if v73 == false then
							if v34 ~= nil then
								(nil):FireServer(v67.Parent, v67, u13, v69, u10(l__HumanoidRootPart__21, v69, v63));
							end;
							u9.Impact(v67, v69, v68, u19, "Ranged", true);
							u23();
							return;
						end;
					else
						if u20 > 2500 or tick() - v59 > 60 then
							u23();
							return;
						end;
						u18 = v69;
						local v79 = tick() - v59;
						u19 = (u18 + u19 * 10000 - Vector3.new(0, v29 / 2 * v79 ^ 2, 0) - u18).Unit;
						table.insert(u21, {
							stepAmount = u17, 
							dropTiming = v79
						});
						u17 = 0;
					end;
				end;
			end);
		end;
		if v32 ~= nil then
			local u24 = 0;
			coroutine.wrap(function()
				while u24 < 3 do
					wait();				
				end;
				u9.RecoilCamera(l__LocalPlayer__7, l__CurrentCamera__14, p12, v40, v41, v31, v36);
			end)();
			for v80 = 1, v32.Value do
				coroutine.wrap(v56)();
				u24 = u24 + 1;
			end;
		else
			coroutine.wrap(v56)();
			u9.RecoilCamera(l__LocalPlayer__7, l__CurrentCamera__14, p12, v40, v41, v31, v36);
		end;
	end;
end;

return v1;
