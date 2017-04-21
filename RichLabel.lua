--[===[--

富文本控件,基于cocos2d-x里的RichText实现
说白了就是抄过来,然后改改...
支持基本富文本功能,也就是说和ccui.RichText一样
另外支持click,shadow,outline,以及解析伪html的格式化字符串
因某大叔的无耻需求,加入了valign的控制,想想算了,把align也加了吧...

感觉使用越来越麻烦了...
分为两种使用模式:格式化文本 和 代码编写
格式化文本时传递的构造参数只是个文本,而代码编写传递的是table进行初始设置
文本的default标签内容其实就等于代码编写的初始设置

1.格式化文本,可填写的内容
	a. default标签 <default key=value ... />
		写在格式化文本的第一个,当然也可以没有,没有就是用默认的,其可用的属性如下
		int 	size 	字体大小, 默认同TTFLabel
		string 	font 	字体, 默认同TTFLabel
		color3 	color 	字体颜色, 默认同TTFLabel
		int 	verticalSpace 	垂直间隔, 默认0
		int 	width 	宽度,设定就可以自动换行了,不设定就是单行
		int 	height 	高度
		string 	valign 	垂直对齐方式, top center bottom, 默认bottom
		string 	align 	水平对齐方式, left center right, 默认left
	b.无标签文本
		直接以default里的属性进行生成的文本,所有无标签的都这样处理
	c.文本标签 <text key=value ... >content</text>
		不采用default属性生成的文本,其属性来自自身定义,若自身没有定义的则使用default中的定义
		除文本生成时的属性,即TTFLabel中的属性外,还可使用以下属性来定义相应功能
		int 	opacity 	透明度
		bool 	clickable 	是否可点击,可点击时将会把本控件及本控件使用的属性当作参数来调用回调方法
		int 	tag 		tag值可用于取出指定元素
		string 	name 		名称,同tag用法
		int 	rotation 	旋转
		float 	scale 		缩放比例
		color4 	shadow_color 启用阴影,阴影颜色,默认为cc.c4b(0, 0, 0, 255)
		int 	shadow_blur 启用阴影,blur值,默认为0
		int 	shadow_x 	启用阴影,x轴偏移值,默认为2
		int 	shadow_y 	启用阴影,y轴偏移值,默认为-2
		color4 	outline_color 启用outline,颜色,默认为cc.c4b(0, 0, 0, 255)
		int 	outline_size 启用outline,size值,默认为2
	d.图片标签 <image key=value ... >image path</image>
		就是图片啦,其可使用的属性如下
		int 	opacity 	透明度
		bool 	clickable 	是否可点击,可点击时将会把本控件及本控件使用的属性当作参数来调用回调方法
		int 	tag 		tag值可用于取出指定元素
		string 	name 		名称,同tag用法
		int 	rotation 	旋转
		float 	scale 		缩放比例
		bool 	flipX 		X轴翻转
		bool 	flipY 		Y轴翻转
	e.自定义标签
		很遗憾,你想太多了,没这东东 wbs

2.代码编写
	1.初始构造参数为table,参数如下
		int 	fontSize 		字体大小, 默认同TTFLabel
		string 	font 			字体, 默认同TTFLabel
		color3 	fontColor 		字体颜色, 默认同TTFLabel
		int 	verticalSpace 	垂直间隔, 默认0
		cc.size size 			控件尺寸, 默认为(0, 0)
		bool 	ignoreSize 		是否忽略尺寸,true则是单行的,false则根据size属性自动断行,不设定会自动根据size.width设置
		string 	valign 			垂直对齐方式, top center bottom, 默认bottom
		string 	align 			水平对齐方式, left center right, 默认left
	2.添加元素 insertElement insertText insertImage insertCustom
		第一个参数为table,用来描述此元素属性定义,可参看上面1.c和1.d,有些地方的设定略有不同,可参看例子,
			但有个type属性来说明是什么类型元素,text时可不设置这个type
		第二个参数是插入位置,不设置则加入到末尾
	3.移除元素 removeElement
	4.一定要手动refresh下

e.g.
	1.格式化文本
	local rl = RichLabel.new([[<default color=#00ff00 size=20 width=100/>这样<text 
				color=#ff0000 size=30 clickable=true shadow_color=#ffffff00 tag=10
				shadow_blur=2 shadow_offset_x=2 shadow_offset_y=-2>能</text><image 
				clickable=true name=a10>demo/RadioButtonOn.png</image><br>哈哈]])
                :addTo(self):center()
                :onClick(function ( node, params )
                    dump(params)
                end)
    rl:foreachElements(function ( node, tag )
            node:runAction(cc.RepeatForever:create(transition.sequence{
                cc.FadeOut:create(0.5),
                cc.FadeIn:create(0.5)
            }))
        end, 10, "a10")

	2.代码编写
    local rl = RichLabel.new{ignoreSize = false, size = cc.size(100, 0) }
    rl:insertElement({text = "我", color = cc.c3b(255, 0, 0), size = 16, clickable = true})
    rl:insertElement({text = "\n", color = cc.c3b(255, 0, 0), size = 16})
    rl:insertElement({text = "也", color = cc.c3b(0, 255, 0), size = 18, shadow = {color = cc.c4b(0, 0, 0, 255), blur = 2, offset = cc.size(2, -2)} })
    rl:insertElement({ type = rl.TYPE_IMAGE, file = "demo/RadioButtonOn.png", clickable = true, tag = 100})
    rl:insertElement({text = "不", color = cc.c3b(0, 0, 255), size = 20, outline = {color = cc.c4b(0, 0, 0, 255), size = 2}})
    rl:insertElement({text = "明", color = cc.c3b(255, 255, 0), size = 22})
    rl:insertElement({text = "白", color = cc.c3b(255, 0, 255), size = 24})
    rl:insertElement({text = ",", color = cc.c3b(0, 255, 255), size = 22})
    rl:insertElement({text = "h", color = cc.c3b(255, 0, 120), size = 20})
    rl:insertElement({text = "o", color = cc.c3b(255, 120, 0), size = 14})
    rl:insertElement({text = "w", color = cc.c3b(255, 120, 120), size = 16})
    rl:addTo(self):center()
    rl:refresh()
    rl:onClick(function ( who, params )
        dump(params)
    end)
    local img = rl:getElement(100)
    if img then 
        img:runAction(cc.RepeatForever:create(transition.sequence{
            cc.FadeOut:create(0.5),
            cc.FadeIn:create(0.5)
        }))
    end

-- @author chengfu.bao 
-- Creation 2015/2/6
--]===]--
local RichLabel = class("RichLabel", function (  )
	return display.newNode()
end)
-- https://github.com/tst2005/lua-utf8
local ustring = assert(import(".utf8"))

local cc = cc
local math = assert(require("math"))
local math_floor = math.floor
local math_max = math.max
local table = assert(require("table"))
local table_insert = table.insert
local table_remove = table.remove
local string = assert(require("string"))
local string_gsub = string.gsub
local string_find = string.find
local string_byte = string.byte
local string_len = string.len
local string_sub = string.sub
local string_gmatch = string.gmatch
local string_split = string.split
local string_lower = string.lower
local tostring = tostring
local ipairs = ipairs
local tonumber = tonumber
local util_each = function ( fun, params )
	table.walk(params, fun)
end
local util_filter = function ( fun, params )
	table.filter(params, fun)
end
local function table_isnotempty( t )
	return next(t) ~= nil
end
local isstring = function(v) return "string" == type(v) end
local isnumber = function(v) return "number" == type(v) end

RichLabel.TYPE_TEXT = "text"
RichLabel.TYPE_IMAGE = "image"
RichLabel.TYPE_CUSTOM = "custom"

RichLabel.VALIGN_TOP = "top"
RichLabel.VALIGN_CENTER = "center"
RichLabel.VALIGN_BOTTOM = "bottom"
RichLabel.ALIGN_LEFT = "left"
RichLabel.ALIGN_CENTER = "center"
RichLabel.ALIGN_RIGHT = "right"

local CC_SIZE_ZERO = cc.size(0, 0)

function RichLabel:ctor( params )
	if isstring(params) then 
		-- 处理下只传递格式字符进来,简化创建
		self.text_ = params
		params = nil
	end
	self.params_ = params or {}
	-- 你第一次肯定就是脏的
	self.formatTextDirty_ = true
	self.leftSpaceWidth_ = 0

	self.params_.size = self.params_.size or CC_SIZE_ZERO
	self.fontSize_ = self.params_.fontSize -- or display.DEFAULT_TTF_FONT_SIZE
	self.font_ = self.params_.font -- or display.DEFAULT_TTF_FONT
	self.fontColor_ = self.params_.fontColor -- or display.COLOR_WHITE
	self.verticalSpace_ = self.params_.verticalSpace or 0
	-- self.ignoreSize_ = ifnil(self.params_.ignoreSize, not (self.params_.size.width > 0))
	if self.ignoreSize_ == nil then 
		self.ignoreSize_ = not (self.params_.size.width > 0)
	end
	self.valign_ = string_lower(self.params_.valign or RichLabel.VALIGN_BOTTOM)
	self.align_ = string_lower(self.params_.align or RichLabel.ALIGN_LEFT)

	self.onClick_ = self.params_.onClick
	-- 每个元素的配置项
	self.elementsParams_ = self.params_.elementsParams or {}
	-- 元素所属的父容器
	self.elementRenderersContainer_ = display.newNode():addTo(self, 0, -1)
	-- 进行格式字符处理
	if self.text_ then
		self:parseString_(self.text_) 
	end
	-- 刷新显示去吧~~~
	if table_isnotempty(self.elementsParams_) then 
		self:refresh()
	end
end
--[[--

绑定属性到node上

@param Node node 
@param table params node配置,包含
						int 	opacity 	透明度
						bool 	clickable 	是否可点击
						int 	tag 		tag值可用于取出指定元素
						string 	name 		名称,同tag用
						int 	rotation 	旋转
						float 	scale 		缩放比例
						bool 	flipX 		X轴翻转
						bool 	flipY 		Y轴翻转

--]]
function RichLabel:bindParams_( node, params )
	if params.opacity then 
		node:setOpacity(params.opacity)
	end
	if params.clickable then 
		node:setTouchEnabled(true)
	    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "ended" then
	            if self.onClick_ then
	            	local point = cc.p(event.x, event.y)
	            	if node:getCascadeBoundingBox():containsPoint(point) then 
	            		self.onClick_(node, params)
	            	end
	            end
	        end
	        return true
	    end)
	end
	if params.tag then 
		node:setTag(params.tag)
	end
	if params.name then 
		node:setName(params.name)
	end
	if params.rotation then 
		node:rotation(params.rotation)
	end
	if params.scale then 
		node:scale(params.scale)
	end
	if params.flipX and node.flipX then 
		node:flipX(params.flipX)
	end
	if params.flipY and node.flipY then 
		node:flipY(params.flipY)
	end
end
--[[--

创建TTFLabel

@param table params 属性

@return TTFLabel

--]]
function RichLabel:createTTFLabel_( params )
	if not params.font then 
		params.font = self.font_
	end
	if not params.size then 
		params.size = self.fontSize_
	end
	if not params.color then 
		params.color = self.fontColor_
	end
	local label = cc.ui.UILabel.new(params)
    if params.shadow then
        local color4 = params.shadow.color or cc.c4b(0, 0, 0, 255)
        local offset = params.shadow.offset or {}
        if not offset.width then offset.width = 2 end
        if not offset.height then offset.height = -2 end
        local blur = params.shadow.blur or 0
        label:enableShadow(color4, offset, blur)
    end
    if params.outline then 
        local color4 = params.outline.color or cc.c4b(0, 0, 0, 255)
        local size = params.outline.size or 2
        label:enableOutline(color4, size)
    end
    return label
end
--[[--

尺寸限制条件下,处理TTFLable,当宽度不够时自动换到下一行

@param table elementParams 文本元素属性

--]]
function RichLabel:handleTextRenderer_( elementParams )
	-- 处理下换行,只是用这个[br]好还是不好,纠结啊~~~
	if "[br]" == elementParams.text or "\n" == elementParams.text then 
		self:addNewLine_()
		local params = clone(elementParams)
		params.text = "\n"
		local textRenderer = self:createTTFLabel_(params)
		self:pushToContainer_(textRenderer)
		return 
	end
	local textRenderer = self:createTTFLabel_(elementParams)
	local textRendererWidth = textRenderer:getContentSize().width * textRenderer:getScale()
	self.leftSpaceWidth_ = self.leftSpaceWidth_ - textRendererWidth
	-- 采用了显示宽度百分比与字符个数百分比的对应方式,虽然不精确,但快速,需要更精确的还要去微调
	-- 至于单词的warp,就算了吧,想想都觉得麻烦,哈哈哈哈
	if self.leftSpaceWidth_ < 0 then 
		local overstepPercent = (-self.leftSpaceWidth_) / textRendererWidth
		local curText = ustring(elementParams.text)
		local stringLength = ustring.len(curText)
		local leftLength = math_floor(stringLength * (1 - overstepPercent))
		if leftLength > 0 then 
			local leftWords = ustring.sub(curText, 1, leftLength)
			local params = clone(elementParams)
			params.text = tostring(leftWords)
			local leftRenderer = self:createTTFLabel_(params)
			if leftRenderer then 
				self:bindParams_(leftRenderer, params)
				self:pushToContainer_(leftRenderer)
			end
		end
		self:addNewLine_()
		local cutWords = ustring.sub(curText, leftLength + 1, stringLength)
		local params = clone(elementParams)
		params.text = tostring(cutWords)
		self:handleTextRenderer_(params)
	else
		self:bindParams_(textRenderer, elementParams)
		self:pushToContainer_(textRenderer)
	end
end
--[[--

尺寸限制条件下,处理图片,当宽度不够时自动换到下一行

@param table elementParams 图片元素属性

--]]
function RichLabel:handleImageRenderer_( elementParams )
	local imageRenderer = display.newSprite(elementParams.file)
	self:handleCustomRenderer_(imageRenderer, elementParams)
end
--[[--

尺寸限制条件下,处理自定义控件,当宽度不够时自动换到下一行

@param Node renderer 自定义控件
@param table elementParams 自定义元素属性

--]]
function RichLabel:handleCustomRenderer_( renderer, elementParams )
	local size = renderer:getContentSize()
	self.leftSpaceWidth_ = self.leftSpaceWidth_ - size.width * renderer:getScale()
	if self.leftSpaceWidth_ < 0 then 
		self:addNewLine_()
		self.leftSpaceWidth_ = self.leftSpaceWidth_ - size.width * renderer:getScale()
	end
	self:pushToContainer_(renderer)
	self:bindParams_(renderer, elementParams)
end
--[[--

计算所有控件进行格式化输出
在尺寸限制条件下,宽高会被分别设定为设置尺寸和实际尺寸中大的那个值

--]]
function RichLabel:formatRenderers_()
	if self.ignoreSize_ then 
		local newContentSizeWidth = 0
		local newContentSizeHeight = 0
		local row = self.elementRenders_[1]
		local nextPosX = 0
		util_each(function ( element, index )
			element:align(display.BOTTOM_LEFT)
				   :pos(nextPosX, 0)
			self.elementRenderersContainer_:add(element, 1)
			local elementSize = element:getContentSize()
			newContentSizeWidth = newContentSizeWidth + elementSize.width * element:getScale()
			newContentSizeHeight = math_max(newContentSizeHeight, elementSize.height * element:getScale())
			nextPosX = nextPosX + elementSize.width * element:getScale()
		end, row)
		if RichLabel.VALIGN_BOTTOM ~= self.valign_ then 
			local anchor, posY
			if RichLabel.VALIGN_TOP == self.valign_ then 
				anchor = display.TOP_LEFT
				posY = newContentSizeHeight
			elseif RichLabel.VALIGN_CENTER == self.valign_ then
				anchor = display.CENTER_LEFT
				posY = newContentSizeHeight / 2
			end
			util_each(function ( element, index )
				element:align(anchor):pos(element:getPositionX(), posY)
			end, row)
		end

		self.elementRenderersContainer_:size(newContentSizeWidth, newContentSizeHeight)
		self:size(newContentSizeWidth, newContentSizeHeight)
	else
		local newContentSizeHeight = 0
		local newContentSizeWidth = 0
		local maxHeights = {}
		local maxWidths = {}
		util_each(function ( elementRender, index )
			local maxHeight = 0
			local maxWidth = 0
			util_each(function ( element, elementIndex )
				maxHeight = math_max(element:getContentSize().height * element:getScale(), maxHeight)
				maxWidth = maxWidth + element:getContentSize().width * element:getScale()
			end, elementRender)
			maxHeights[index] = maxHeight
			maxWidths[index] = maxWidth
			newContentSizeHeight = newContentSizeHeight + maxHeight
			newContentSizeWidth = math_max(newContentSizeWidth, maxWidth)
		end, self.elementRenders_)

		newContentSizeWidth = math_max(newContentSizeWidth, self.params_.size.width)
		newContentSizeHeight = math_max(newContentSizeHeight, self.params_.size.height)
		self.elementRenderersContainer_:size(newContentSizeWidth, newContentSizeHeight)
		self:size(newContentSizeWidth, newContentSizeHeight)

		local nextPosY = newContentSizeHeight
		util_each(function ( elementRender, index )
			local nextPosX = 0
			nextPosY = nextPosY - (maxHeights[index] + self.verticalSpace_)
			local offsetY = 0
			local anchor = display.BOTTOM_LEFT
			local posY = nextPosY
			if RichLabel.VALIGN_TOP == self.valign_ then 
				anchor = display.TOP_LEFT
				posY = nextPosY + maxHeights[index]
			elseif RichLabel.VALIGN_CENTER == self.valign_ then
				anchor = display.CENTER_LEFT
				posY = nextPosY + maxHeights[index] / 2
			end
			if RichLabel.ALIGN_RIGHT == self.align_ then 
				nextPosX = newContentSizeWidth - maxWidths[index]
			elseif RichLabel.ALIGN_CENTER == self.align_ then
				nextPosX = (newContentSizeWidth - maxWidths[index]) / 2
			end
			util_each(function ( element, elementIndex )
				element:align(anchor):pos(nextPosX, posY)
				self.elementRenderersContainer_:add(element, 1)
				nextPosX = nextPosX + element:getContentSize().width * element:getScale()
			end, elementRender)
		end, self.elementRenders_)
	end

	self.elementRenders_ = {}
	self.elementRenderersContainer_:alignParent(display.CENTER)
end
--[[--

加一空行

--]]
function RichLabel:addNewLine_()
	self.leftSpaceWidth_ = self.params_.size.width
	table_insert(self.elementRenders_, {})
end
--[[--

扔到容器中去

@param Node elementRenderer 创建好的控件

--]]
function RichLabel:pushToContainer_( elementRenderer )
	if table_isnotempty(self.elementRenders_) then 
		table_insert(self.elementRenders_[#self.elementRenders_], elementRenderer)
	end
end
--[[--

设置垂直间隔

@param int space 垂直间隔

@return self

--]]
function RichLabel:setVerticalSpace( space )
	self.verticalSpace_ = space
	return self
end
--[[--

设置是否忽略尺寸

@param bool ignore 是否忽略尺寸

@return self

--]]
function RichLabel:ingoreSize( ignore )
	self.ignoreSize_ = ignore
	return self
end
--[[--

设置点击事件

@param fun(node,params) onclick 点击事件,返回点击的控件及创建时的参数

@return self

--]]
function RichLabel:onClick( onclick )
	self.onClick_ = onclick
	return self
end
--[[--

设置默认属性

@param table params 默认属性,包含
					int 	size 	字体大小, 默认同TTFLabel
					string 	font 	字体, 默认同TTFLabel
					color3 	color 	字体颜色, 默认同TTFLabel
					int 	verticalSpace 	垂直间隔, 默认0
					int 	width 	宽度,设定就可以自动换行了,不设定就是单行
					int 	height 	高度
					string 	valign 	垂直对齐方式, top center bottom, 默认bottom
					string 	align 	水平对齐方式, left center right, 默认left

@return self

--]]
function RichLabel:setDefaultParams( params )
	self.fontSize_ = params.size or self.fontSize_
	self.font_ = params.font or self.font_
	self.fontColor_ = params.color or self.fontColor_
	self.verticalSpace_ = params.verticalSpace or self.verticalSpace_
	self.valign_ = string_lower(params.valign or self.valign_)
	self.align_ = string_lower(params.align or self.align_)
	if params.width or params.height then 
		self.params_.size = cc.size(params.width or 0, params.height or 0)
	end
	if not params.width or 0 >= params.width then 
		self.ignoreSize_ = true
	else
		self.ignoreSize_ = false
		self.params_.size = cc.size(params.width, params.height or 0)
	end
	return self
end
--[[--

插入元素属性,用以顺序创建对应控件

@param table elementParams 元素属性
@param int index 	插入下标,无则加入最后一项

@return self

--]]
function RichLabel:insertElement( elementParams, index )
	if index then 
		table_insert(self.elementsParams_, index, elementParams)
	else
		table_insert(self.elementsParams_, elementParams)
	end
	self.formatTextDirty_ = true
	return self
end
--[[--

插入文本元素属性,用以顺序创建对应控件

@param table elementParams 元素属性, 参看顶部说明及例子
@param int index 	插入下标,无则加入最后一项

@return self

--]]
function RichLabel:insertText( elementParams, index )
	elementParams.type = RichLabel.TYPE_TEXT
	return self:insertElement(elementParams, index)
end
--[[--

插入图片元素属性,用以顺序创建对应控件

@param table elementParams 元素属性, 参看顶部说明及例子
@param int index 	插入下标,无则加入最后一项

@return self

--]]
function RichLabel:insertImage( elementParams, index )
	elementParams.type = RichLabel.TYPE_IMAGE
	return self:insertElement(elementParams, index)
end
--[[--

插入自定义元素属性,用以顺序创建对应控件

@param table elementParams 元素属性, 参看顶部说明及例子
@param int index 	插入下标,无则加入最后一项

@return self

--]]
function RichLabel:insertCustom( elementParams, index )
	elementParams.type = RichLabel.TYPE_CUSTOM
	return self:insertElement(elementParams, index)
end
--[[--

删除元素属性,刷新后对应控件消失...

@param int index 	删除下标

@return self

--]]
function RichLabel:removeElement( index )
	table_remove(self.elementsParams_, index)
	self.formatTextDirty_ = true
	return self
end
--[[--

刷新显示

@return self

--]]
function RichLabel:refresh()
	if self.formatTextDirty_ then 
		self.elementRenderersContainer_:removeAllChildren()
		self.elementRenders_ = {}
		if self.ignoreSize_ then 
			self:addNewLine_()
			util_each(function ( elementParams, index )
				local elementRenderer
				local elementType = elementParams.type
				if not elementType or RichLabel.TYPE_TEXT == elementType then 
					elementRenderer = self:createTTFLabel_(elementParams)
				elseif RichLabel.TYPE_IMAGE == elementType then 
					elementRenderer = display.newSprite(elementParams.file)
				elseif RichLabel.TYPE_CUSTOM == elementType then 
					elementRenderer = elementParams.node
				end
				if elementRenderer then 
					self:bindParams_(elementRenderer, elementParams)
					self:pushToContainer_(elementRenderer)
				end
			end, self.elementsParams_)
		else
			self:addNewLine_()
			util_each(function ( elementParams, index )
				local elementType = elementParams.type
				if not elementType or RichLabel.TYPE_TEXT == elementType then 
					self:handleTextRenderer_(elementParams)
				elseif RichLabel.TYPE_IMAGE == elementType then 
					self:handleImageRenderer_(elementParams)
				elseif RichLabel.TYPE_CUSTOM == elementType then 
					self:handleCustomRenderer_(elementParams.node, elementParams)
				end
			end, self.elementsParams_)
		end
		self:formatRenderers_()
		self.formatTextDirty_ = false
	end
	return self
end
--[[--

通过tag/name取得元素控件,只取出第一个

@param int tag 控件tag/name

@return 对应控件

--]]
function RichLabel:getElement( tag )
	if isnumber(tag) then 
		return self.elementRenderersContainer_:getChildByTag(tag)
	else
		return self.elementRenderersContainer_:getChildByName(tag)
	end
end
--[[--

通过tag/name取得元素控件,取出所有同tag的控件

@param int tag 控件tag/name

@return 对应控件table

--]]
function RichLabel:getElements( tag )
	local numberflag = isnumber(tag)
	local result = self.elementRenderersContainer_:getChildren()
	util_filter(function ( node, index )
		if numberflag then 
			return node:getTag() == tag
		else
			return node:getName() == tag
		end
	end, result)
	return result
end
--[[--

遍历指定tag/name的控件执行回调

@param fun(node,tag,index) fun 回调函数
@param ... tag/name

@return 处理的node数量

--]]
function RichLabel:foreachElements( fun, ... )
	local tags = { ... }
	local count = 0
	util_each(function ( tag, index )
		util_each(function ( element, elementIndex )
			fun(element, tag, elementIndex)
			count = count + 1
		end, self:getElements(tag))
	end, tags)
	return count
end

--[[--

编码

@param string text 待编码文本

@return 编码后文本

--]]
local function encodeText_( text )
	local result = text
	result = string_gsub(result, "&", "&amp;")
	result = string_gsub(result, [[\<]], "&lt;")
	result = string_gsub(result, [[\>]], "&gt;")
	return result
end
--[[--

解码

@param string text 待解码文本

@return 解码后文本

--]]
local function decodeText_( text )
	local result = text
	if string_find(result, "&lt;") then 
		result = string_gsub(result, "&lt;", "<")
	end
	if string_find(result, "&gt;") then 
		result = string_gsub(result, "&gt;", ">")
	end
	if string_find(result, "&amp;") then 
		result = string_gsub(result, "&amp;", "&")
	end
	return result
end
--[[--

hex颜色值转换在cc.c3b或cc.c4b

@param string color 颜色hex值,支持rgb和argb格式

@return 对应的cc.c3b或cc.c4b

--]]
local function convertColor_( color )
	local startIndex = 1
	-- #字号
	if 35 == string_byte(color) then 
		startIndex = 2
	end
	local function calPure_()
		local result = string_sub(color, startIndex, startIndex + 1)
		startIndex = startIndex + 2
		return checkint("0x" .. result)
	end
	local result = {}
	if 8 <= string_len(color) then 
		result[#result + 1] = calPure_() -- a
	end
	result[#result + 1] = calPure_() -- r
	result[#result + 1] = calPure_() -- g
	result[#result + 1] = calPure_() -- b
	if 3 < #result then 
		return cc.c4b(result[2], result[3], result[4], result[1])
	else
		return cc.c3b(result[1], result[2], result[3])
	end
end
--[[--

解析格式化字符串,太tmd麻烦了,优化再说...

@param string str 格式化字符串

--]]
function RichLabel:parseString_( str )
	str = string_gsub(str, "/>", " />")
	str = string_gsub(str, "<br>", "<br />")
	str = encodeText_(str)
	local items = {}
	-- 第一段文字处理,没有default,没有标签开头的情况
	local startIndex, endIndex = string_find(str, "<")
	if startIndex and startIndex > 1 then 
		local text = string_sub(str, 1, startIndex - 1)
		table_insert(items, {property="<text>", text = decodeText_(text)})
	end
	-- 拿出每段来处理, 以<>间的为一段先,然后再以><为下一段,直至没有为止
	startIndex, endIndex = string_find(str, "%b<>", 1)
	while startIndex do
		local label = string_sub(str, startIndex, endIndex)
		local endflag = false
		if string_find(label, "^</") then
			-- 总算结尾了, >...</ 的就是此次的主体内容
			local item = items[#items]
			local text = string_sub(str, item.endIndex + 1, startIndex - 1)
			item.text = decodeText_(text)
			endflag = true
		elseif string_find(label, "/>$") then 
			-- 还要考虑下自结束的家伙,其中的br又是特例中的特例
			if "<br />" == label then
				table_insert(items, {property = label, text = "[br]", endIndex = endIndex}) 
			else
				table_insert(items, {property = label})
			end
			endflag = true
		else
			-- 大众项,一般处理
			table_insert(items, {property = label, endIndex = endIndex})
		end
		if endflag then 
			-- 处理结尾标签后的内容,如果不在其它标签内,则看作一般文字项,前提是要有内容
			local startIndex1, endIndex1 = string_find(str, ">.-<", endIndex)
			if startIndex1 then 
				local text = string_sub(str, startIndex1 + 1, endIndex1 - 1)
				if string.trim(text) ~= "" then 
					table_insert(items, {property="<text>", text = decodeText_(text), endIndex = endIndex1})
				end
				endIndex = endIndex1
			end
		end
		local nextEndIndex
		startIndex, nextEndIndex = string_find(str, "%b<>", endIndex)
		-- 保持住最后一个结束位置,以便最后一段的处理
		if startIndex then 
			endIndex = nextEndIndex
		end
	end
	-- 对最后一段处理,没有<来进行结尾了,硬取吧
	endIndex = endIndex or 0
	if endIndex < string_len(str) then 
		local text = string_sub(str, endIndex + 1, string_len(str))
		table_insert(items, {property="<text>", text = decodeText_(text)})
	end 
	-- 处理上面的每段数据,也就只有文字和图片,自定义项在格式文本中定义不出来吧
	for i, item in ipairs(items) do
		local label = item.property
		if string_find(label, "^<text") then 
			item.type = "text"
		elseif string_find(label, "^<image") then 
			item.type = "image"
			item.file = item.text
			item.text = nil
		elseif string_find(label, "^<default") then 
			item.type = "default"
		end
		label = string_sub(label, 2, -2)
		-- 取出属性键值对
		-- TODO:最好把非键值对的也处理了,比如clickable=true,明显clickable就可以了
		for key, value in string_gmatch(label, "([%a_]+)%s*=%s*([%w%p]+)") do
			if value and tonumber(value) then 
				value = tonumber(value)
			elseif "true" == value then 
				value = true
			elseif "false" == value then 
				value = false
			end
			if "color" == key then 
				value = convertColor_(value)
			end
			-- 这里是用 _ 来做层级的分隔,shadow_color表示的是shadow = { color = ... , }, 所以其它时候是不能用_的
			if string_find(key, "_") then 
				local keys = string_split(key, "_")
				local curTable =  item
				for i = 1, #keys - 1 do
					local tempKey = keys[i]
					if not curTable[tempKey] then
						curTable[tempKey] = {}
					end
					curTable = curTable[tempKey]
				end
				local lastKey = keys[#keys]
				if "color" == lastKey then 
					curTable[lastKey] = convertColor_(value)
				else
					curTable[lastKey] = value
				end
			else
				item[key] = value
			end
		end
		item.property = nil
		item.startIndex = nil
		item.endIndex = nil
	end
	local startIndex
	if "default" == items[1].type then 
		self:setDefaultParams(items[1])
		startIndex = 2
	else
		startIndex = 1
	end
	-- 处理换行符的,在标签间的使用\n来换行,标签外的用<br>
	if not self.ignoreSize_ then 
		for i, item in ipairs(items) do
			if "text" == item.type then 
				local startIndex, endIndex = string_find(item.text, "\n")
				if startIndex and item.text ~= "\n" then 
					local text = item.text
					local pre = string_sub(text, 1, startIndex - 1)
					local other = string_sub(text, endIndex + 1)
					item.text = pre
					local nrItem = clone(item)
					nrItem.text = "[br]"
					table_insert(items, i + 1, nrItem)
					local newItem = clone(item)
					newItem.text = other
					table_insert(items, i + 2, newItem)
				end
			end
		end
	end
	for i = startIndex, #items do
		self:insertElement(items[i])
	end
end

return RichLabel