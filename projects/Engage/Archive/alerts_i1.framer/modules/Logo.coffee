# Logo
# Authors: Steve Ruiz
# Last Edited: 28 Sep 17

{ Colors } = require 'Colors'

class exports.Logo extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		@_type
		options.type ?= 'logotype'

		@_color
		options.color ?= 'black'

		_.assign options,
			backgroundColor: null
			border: 'none'
			fill: 'none'
			borderWidth: 0
			borderRadius: 0
			style:
				lineHeight: 0

		@svg = options.svg
				
		super _.defaults options,
			name: 'Logo'

		@_base =
			x: options.x
			y: options.y

		@color = options.color

		delete @__constructor
		
		# set properties

		@color = options.color

		@on "change:color", @setType
		@on "change:type", @setType

		@type = options.type

	setType: ->
		switch @type
			when "logo"
				@width = 30
				@height = 31
			when "logotype"
				@width = 126
				@height = 20
			when "logomark"
				@width = 120
				@height = 16

		svg = svgs[@type]

		Utils.delay 0, =>
			[@x, @y] = [@_base.x, @_base.y]
			@html = """
				<svg 
					xmlns='http://www.w3.org/2000/svg' 
					width='#{@width}px' 
					height='#{@height}px' 
					viewBox='0 0 #{@width} #{@height}'>
						<path
							d='#{svg}' 
							fill='#{@color}'
						/>
				</svg>
				"""	

	@define "color",
		get: -> return @_color
		set: (string) ->
			return if @__constructor

			color = Colors.validate(string)

			@_color = color
			@emit "change:color", string, @

	@define "type",
		get: -> return @_type
		set: (type) ->
			return if @__constructor

			validTypes = ['logo', 'logomark', 'logotype']
			if not _.includes(validTypes, type)
				throw "Logo.type must be 'logo', 'logomark', or 'logotype.'"

			@_type = type
			@emit "change:type", type, @

# svgs
svgs = 
	logo: "M8.13233725,26.4331638 C8.13233725,24.1488163 6.30736393,22.2887048 4.06616862,22.2887048 C1.82497332,22.2887048 0,24.1488163 0,26.4331638 C0,28.7175113 1.82497332,30.5776228 4.06616862,30.5776228 C6.30736393,30.5776228 8.13233725,28.7175113 8.13233725,26.4331638 Z M30,0 L1.1846318,0 L1.1846318,16.8715379 C2.08110993,16.5778361 3.07363927,16.4473019 4.06616862,16.4473019 C5.05869797,16.4473019 6.05122732,16.6104696 6.94770544,16.9041714 L6.94770544,5.90666993 L24.2369264,5.90666993 L24.2369264,23.5287791 L13.4471718,23.5287791 C13.7353255,24.4425181 13.8633938,25.4541577 13.8633938,26.4657973 C13.8633938,27.4774369 13.7033084,28.4890765 13.4151547,29.4028155 L29.9679829,29.4028155 L29.9679829,0 L30,0 Z"
	logotype: "M17.1686747,0.465107058 L20.7028112,0.465107058 L20.7028112,18.6649485 L17.1686747,18.6649485 L17.1686747,0.465107058 Z M33.4337349,6.71371927 C34.4578313,7.88659794 34.9598394,9.46391753 34.9598394,11.445678 L34.9598394,12.8814433 L25.8032129,12.8814433 C25.8433735,13.9532117 26.1044177,14.7823156 26.6064257,15.388977 C27.1084337,15.9956384 27.8714859,16.2989691 28.875502,16.2989691 C30.2811245,16.2989691 31.1044177,15.7125297 31.3654618,14.519429 L34.7991968,14.519429 C34.5582329,16.0158604 33.9759036,17.148295 33.0120482,17.9167328 C32.0682731,18.6851705 30.6626506,19.0693894 28.8554217,19.0693894 C26.6666667,19.0693894 25.0200803,18.462728 23.9156627,17.2291832 C22.811245,15.9956384 22.248996,14.2767645 22.248996,12.0321174 C22.248996,10.9199048 22.4096386,9.90880254 22.7309237,9.03925456 C23.0522088,8.16970658 23.4939759,7.42149088 24.0763052,6.8148295 C24.6586345,6.20816812 25.3614458,5.74306106 26.1646586,5.41950833 C26.9678715,5.09595559 27.8714859,4.95440127 28.8554217,4.95440127 C30.9036145,4.95440127 32.4297189,5.5408406 33.4337349,6.71371927 Z M31.5662651,10.535686 C31.5662651,9.62569389 31.3453815,8.89770024 30.9036145,8.39214909 C30.4618474,7.88659794 29.7590361,7.62371134 28.815261,7.62371134 C28.3333333,7.62371134 27.9317269,7.70459952 27.5702811,7.84615385 C27.2088353,8.00793021 26.9076305,8.21015067 26.6666667,8.47303727 C26.4257028,8.73592387 26.2248996,9.03925456 26.1044177,9.38302934 C25.9638554,9.72680412 25.8835341,10.111023 25.8835341,10.5154639 L31.5662651,10.5154639 L31.5662651,10.535686 Z M47.8915663,8.04837431 C48.0923695,8.69547978 48.1726908,9.44369548 48.1726908,10.2525773 L48.1726908,18.6649485 L44.8393574,18.6649485 L44.8393574,16.9865186 C44.3172691,17.572958 43.7349398,18.0582871 43.0722892,18.4425059 C42.4297189,18.8065028 41.5863454,19.0087232 40.562249,19.0087232 C39.9799197,19.0087232 39.4176707,18.9278351 38.875502,18.7862807 C38.3534137,18.6245044 37.8714859,18.4020619 37.4899598,18.0785091 C37.0883534,17.7549564 36.7670683,17.3505155 36.5461847,16.8449643 C36.3052209,16.3394132 36.184739,15.7529738 36.184739,15.0452022 C36.184739,14.1352102 36.3855422,13.3869944 36.7871486,12.8005551 C37.188755,12.2141158 37.7309237,11.7692308 38.373494,11.445678 C39.0361446,11.1221253 39.7791165,10.8996828 40.5823293,10.7581285 C41.4056225,10.6165741 42.2289157,10.535686 43.0722892,10.4952419 L44.7590361,10.4143537 L44.7590361,9.74702617 C44.7590361,8.93814433 44.5381526,8.37192704 44.0963855,8.06859635 C43.6546185,7.76526566 43.1124498,7.60348929 42.5100402,7.60348929 C41.1044177,7.60348929 40.3012048,8.12926249 40.1004016,9.20103093 L36.8674699,8.89770024 C37.1084337,7.50237906 37.7108434,6.49127676 38.6947791,5.88461538 C39.6787149,5.25773196 40.9839357,4.95440127 42.6506024,4.95440127 C43.6546185,4.95440127 44.5180723,5.07573354 45.2409639,5.3183981 C45.9437751,5.56106265 46.5261044,5.92505948 46.9477912,6.36994449 C47.3895582,6.83505155 47.6907631,7.40126883 47.8915663,8.04837431 Z M44.7590361,12.739889 L43.1927711,12.8207772 C42.4497992,12.8612213 41.8473896,12.9218874 41.4056225,13.0432197 C40.9437751,13.1645519 40.6024096,13.3061063 40.3614458,13.4881047 C40.1204819,13.6701031 39.9598394,13.8723236 39.8594378,14.1149881 C39.7791165,14.3576527 39.7389558,14.6205393 39.7389558,14.9036479 C39.7389558,15.3485329 39.8995984,15.6923077 40.2008032,15.9551943 C40.502008,16.2180809 40.9236948,16.3394132 41.4658635,16.3394132 C42.3694779,16.3394132 43.1124498,16.1169707 43.6947791,15.6923077 C44.0160643,15.4496431 44.2771084,15.1463125 44.4779116,14.7823156 C44.6787149,14.4183188 44.7791165,13.9532117 44.7791165,13.4274385 L44.7791165,12.739889 L44.7590361,12.739889 Z M57.1285141,5.13639968 C56.4457831,5.13639968 55.7831325,5.3183981 55.1606426,5.66217288 C54.5381526,6.00594766 53.9959839,6.53172086 53.5742972,7.23949247 L53.5742972,5.35884219 L50.1405622,5.35884219 L50.1405622,18.6649485 L53.6746988,18.6649485 L53.6746988,10.9603489 C53.6746988,10.5963521 53.7550201,10.2525773 53.8955823,9.90880254 C54.0361446,9.56502776 54.2570281,9.26169707 54.5582329,8.99881047 C54.8393574,8.73592387 55.1606426,8.5741475 55.5220884,8.47303727 C55.8835341,8.37192704 56.2449799,8.33148295 56.626506,8.33148295 C57.2088353,8.33148295 57.7108434,8.39214909 58.1124498,8.49325932 L58.5341365,5.25773196 C58.373494,5.21728787 58.1726908,5.19706582 57.9518072,5.17684377 C57.7309237,5.15662173 57.4497992,5.13639968 57.1285141,5.13639968 Z M68.7550201,7.88659794 L66.2650602,7.40126883 C65.3614458,7.21927042 64.6987952,6.95638382 64.3373494,6.61260904 C63.9558233,6.26883426 63.7751004,5.76328311 63.7751004,5.07573354 C63.7751004,4.81284695 63.8353414,4.57018239 63.935743,4.32751784 C64.0361446,4.08485329 64.2168675,3.88263283 64.4578313,3.70063442 C64.7188755,3.518636 65.0401606,3.37708168 65.4618474,3.27597145 C65.8835341,3.17486122 66.4056225,3.11419508 67.0481928,3.11419508 C68.1325301,3.11419508 68.935743,3.33663759 69.4578313,3.7815226 C69.9799197,4.22640761 70.3413655,4.95440127 70.5421687,5.94528152 L74.1164659,5.48017446 C74.0361446,4.77240285 73.8554217,4.08485329 73.5943775,3.41752577 C73.3333333,2.75019826 72.9317269,2.16375892 72.3895582,1.67842982 C71.8473896,1.17287867 71.1445783,0.768437748 70.2610442,0.465107058 C69.37751,0.161776368 68.2931727,0 66.9678715,0 C65.9437751,0 65,0.121332276 64.1365462,0.343774782 C63.2730924,0.566217288 62.5301205,0.90999207 61.9277108,1.35487708 C61.3052209,1.79976209 60.8232932,2.34575734 60.4819277,3.01308485 C60.1405622,3.68041237 59.9598394,4.44885012 59.9598394,5.29817605 C59.9598394,6.16772403 60.0803213,6.91593973 60.3413655,7.54282316 C60.6024096,8.16970658 60.9638554,8.69547978 61.4457831,9.14036479 C61.9277108,9.56502776 62.5301205,9.92902458 63.2329317,10.1919112 C63.935743,10.4547978 64.7590361,10.6772403 65.6827309,10.8592387 L68.0321285,11.2839017 C68.9759036,11.4659001 69.6184739,11.7692308 69.9799197,12.1938937 C70.3413655,12.6185567 70.502008,13.0634417 70.502008,13.5285488 C70.502008,13.8723236 70.4417671,14.1756542 70.3413655,14.4789849 C70.2409639,14.7620936 70.060241,15.0249802 69.7991968,15.2272006 C69.5381526,15.4496431 69.2168675,15.6114195 68.815261,15.7327518 C68.4136546,15.8540841 67.9116466,15.9147502 67.3293173,15.9147502 C66.1044177,15.9147502 65.1606426,15.6518636 64.5381526,15.1463125 C63.8955823,14.6407613 63.5542169,13.8116574 63.4538153,12.6994449 L59.6385542,12.6994449 C59.7389558,14.8429818 60.4417671,16.4405234 61.746988,17.5122918 C63.0522088,18.5840603 64.939759,19.1098335 67.4096386,19.1098335 C68.5943775,19.1098335 69.6184739,18.9682791 70.502008,18.6851705 C71.3855422,18.4020619 72.1084337,18.017843 72.6907631,17.5122918 C73.2730924,17.0067407 73.7148594,16.4203013 74.0160643,15.7529738 C74.3172691,15.0856463 74.4578313,14.3374306 74.4578313,13.5487708 C74.4578313,11.890563 73.9959839,10.6367962 73.0923695,9.76724822 C72.1485944,8.91792228 70.7228916,8.27081681 68.7550201,7.88659794 Z M83.7751004,15.6114195 C83.3935743,16.0158604 82.8313253,16.2180809 82.1285141,16.2180809 C81.5863454,16.2180809 81.1445783,16.0967486 80.7831325,15.8743061 C80.4216867,15.6518636 80.1405622,15.3283109 79.939759,14.944092 C79.7389558,14.5598731 79.5983936,14.0947661 79.5180723,13.5892149 C79.437751,13.0836638 79.3975904,12.5376685 79.3975904,11.9916733 C79.3975904,11.445678 79.437751,10.9199048 79.5180723,10.4143537 C79.5983936,9.90880254 79.7590361,9.46391753 79.9598394,9.07969865 C80.1807229,8.69547978 80.4618474,8.37192704 80.8032129,8.14948454 C81.1646586,7.92704203 81.6064257,7.80570975 82.1485944,7.80570975 C82.8915663,7.80570975 83.4136546,8.00793021 83.7148594,8.43259318 C84.0160643,8.85725615 84.2168675,9.40325139 84.2971888,10.0705789 L87.8714859,9.5852498 C87.7911647,8.89770024 87.6104418,8.29103886 87.3694779,7.70459952 C87.1084337,7.13838224 86.7670683,6.65305313 86.3052209,6.24861221 C85.8433735,5.84417129 85.2811245,5.52061856 84.6184739,5.29817605 C83.9558233,5.07573354 83.1726908,4.95440127 82.2690763,4.95440127 C81.2248996,4.95440127 80.3012048,5.11617764 79.4779116,5.45995242 C78.6746988,5.8037272 77.9919679,6.2890563 77.4297189,6.89571768 C76.8674699,7.52260111 76.4457831,8.27081681 76.1445783,9.14036479 C75.8433735,10.0099128 75.7028112,10.980571 75.7028112,12.0321174 C75.7028112,13.0836638 75.8232932,14.054322 76.0843373,14.9036479 C76.3453815,15.7731959 76.7269076,16.5011895 77.2289157,17.128073 C77.751004,17.7347343 78.4136546,18.2200634 79.2168675,18.5638382 C80.0200803,18.907613 80.9839357,19.0693894 82.1084337,19.0693894 C84.0160643,19.0693894 85.4417671,18.6042823 86.4056225,17.6538462 C87.3493976,16.70341 87.9116466,15.4496431 88.0321285,13.8521015 L84.4578313,13.8521015 C84.3975904,14.6205393 84.1566265,15.2069786 83.7751004,15.6114195 Z M102.550201,11.9916733 C102.550201,13.1038858 102.389558,14.0947661 102.088353,14.964314 C101.767068,15.833862 101.325301,16.5820777 100.742972,17.1887391 C100.160643,17.7954005 99.4578313,18.2605075 98.6345382,18.5840603 C97.811245,18.907613 96.8875502,19.0693894 95.8835341,19.0693894 C93.7550201,19.0693894 92.1084337,18.462728 90.9437751,17.2291832 C89.7791165,15.9956384 89.1967871,14.2565424 89.1967871,11.9714512 C89.1967871,10.8794607 89.3574297,9.90880254 89.6586345,9.01903251 C89.9799197,8.14948454 90.4216867,7.40126883 91.0040161,6.79460745 C91.5863454,6.18794607 92.2891566,5.72283902 93.1124498,5.39928628 C93.935743,5.07573354 94.8594378,4.91395718 95.8634538,4.91395718 C96.8875502,4.91395718 97.811245,5.07573354 98.6546185,5.39928628 C99.4779116,5.72283902 100.180723,6.18794607 100.763052,6.79460745 C101.345382,7.40126883 101.787149,8.12926249 102.088353,9.01903251 C102.389558,9.92902458 102.550201,10.8996828 102.550201,11.9916733 Z M98.875502,11.9916733 C98.875502,10.6367962 98.6345382,9.60547185 98.1325301,8.87747819 C97.6305221,8.16970658 96.8875502,7.80570975 95.8634538,7.80570975 C94.8594378,7.80570975 94.0963855,8.16970658 93.5943775,8.87747819 C93.0923695,9.5852498 92.8514056,10.6367962 92.8514056,11.9916733 C92.8514056,13.3667724 93.0923695,14.4183188 93.5943775,15.1463125 C94.0763052,15.8743061 94.8393574,16.2383029 95.8634538,16.2383029 C96.8674699,16.2383029 97.6305221,15.8743061 98.1325301,15.1463125 C98.6345382,14.3980967 98.875502,13.3465504 98.875502,11.9916733 Z M111.104418,5.13639968 C110.421687,5.13639968 109.759036,5.3183981 109.136546,5.66217288 C108.514056,6.00594766 107.971888,6.53172086 107.550201,7.23949247 L107.550201,5.35884219 L104.116466,5.35884219 L104.116466,18.6649485 L107.650602,18.6649485 L107.650602,10.9603489 C107.650602,10.5963521 107.730924,10.2525773 107.871486,9.90880254 C108.012048,9.56502776 108.232932,9.26169707 108.534137,8.99881047 C108.815261,8.73592387 109.136546,8.5741475 109.497992,8.47303727 C109.859438,8.37192704 110.220884,8.33148295 110.60241,8.33148295 C111.184739,8.33148295 111.686747,8.39214909 112.088353,8.49325932 L112.51004,5.25773196 C112.349398,5.21728787 112.148594,5.19706582 111.927711,5.17684377 C111.726908,5.15662173 111.445783,5.13639968 111.104418,5.13639968 Z M125.441767,12.8814433 L116.285141,12.8814433 C116.325301,13.9532117 116.586345,14.7823156 117.088353,15.388977 C117.590361,15.9956384 118.353414,16.2989691 119.35743,16.2989691 C120.763052,16.2989691 121.586345,15.7125297 121.84739,14.519429 L125.281124,14.519429 C125.040161,16.0158604 124.457831,17.148295 123.493976,17.9167328 C122.550201,18.6851705 121.144578,19.0693894 119.337349,19.0693894 C117.148594,19.0693894 115.502008,18.462728 114.39759,17.2291832 C113.293173,15.9956384 112.730924,14.2767645 112.730924,12.0321174 C112.730924,10.9199048 112.891566,9.90880254 113.212851,9.03925456 C113.534137,8.16970658 113.975904,7.42149088 114.558233,6.8148295 C115.140562,6.20816812 115.843373,5.74306106 116.646586,5.41950833 C117.449799,5.09595559 118.353414,4.95440127 119.337349,4.95440127 C121.365462,4.95440127 122.891566,5.5408406 123.915663,6.71371927 C124.939759,7.88659794 125.441767,9.46391753 125.441767,11.445678 L125.441767,12.8814433 L125.441767,12.8814433 Z M122.028112,10.535686 C122.028112,9.62569389 121.807229,8.89770024 121.365462,8.39214909 C120.923695,7.88659794 120.220884,7.62371134 119.277108,7.62371134 C118.795181,7.62371134 118.393574,7.70459952 118.032129,7.84615385 C117.670683,8.00793021 117.369478,8.21015067 117.128514,8.47303727 C116.88755,8.73592387 116.686747,9.03925456 116.566265,9.38302934 C116.425703,9.72680412 116.345382,10.111023 116.345382,10.5154639 L122.028112,10.5154639 L122.028112,10.535686 Z M14.939759,15.4900872 C15.1606426,15.0047581 15.3413655,14.4587629 15.502008,13.8925456 L11.9477912,12.5578906 C11.9477912,12.5578906 11.9477912,12.5578906 11.9477912,12.5781126 C11.8072289,13.609437 11.4658635,14.3980967 10.9437751,14.964314 C10.4016064,15.5709754 9.53815261,15.8743061 8.37349398,15.8743061 C6.92771084,15.8743061 5.82329317,15.3283109 5.06024096,14.2363204 C4.31726908,13.1443299 3.93574297,11.5872324 3.93574297,9.5852498 L3.93574297,9.5852498 L3.93574297,9.5852498 L3.93574297,9.5852498 L3.93574297,9.5852498 C3.93574297,7.58326725 4.31726908,6.02616971 5.06024096,4.93417922 C5.80321285,3.84218874 6.90763052,3.2961935 8.37349398,3.2961935 C9.53815261,3.2961935 10.4016064,3.59952419 10.9437751,4.20618557 C11.4658635,4.77240285 11.7871486,5.58128469 11.9477912,6.59238699 C11.9477912,6.59238699 11.9477912,6.59238699 11.9477912,6.61260904 L15.502008,5.277954 C15.3413655,4.71173672 15.1606426,4.18596352 14.939759,3.68041237 C14.5783133,2.91197462 14.1164659,2.26486915 13.5341365,1.71887391 C13.3935743,1.57731959 13.2329317,1.45598731 13.0722892,1.33465504 C13.0522088,1.33465504 13.0522088,1.31443299 13.0321285,1.31443299 C12.9317269,1.25376685 12.8514056,1.19310071 12.751004,1.13243458 C12.3694779,0.90999207 11.9678715,0.70777161 11.5261044,0.545995242 C10.6024096,0.20222046 9.55823293,0.040444092 8.33333333,0.040444092 C7.04819277,0.040444092 5.88353414,0.262886598 4.87951807,0.70777161 C3.85542169,1.15265662 2.97188755,1.77954005 2.24899598,2.62886598 C1.52610442,3.45796987 0.963855422,4.46907216 0.582329317,5.64195083 C0.301204819,6.51149881 0.120481928,7.48215702 0.0401606426,8.53370341 C0.0401606426,8.53370341 0.0401606426,8.53370341 0.0401606426,8.55392546 C0.0200803213,8.89770024 1.42108547e-14,9.26169707 1.42108547e-14,9.62569389 C1.42108547e-14,9.98969072 0.0200803213,10.3536875 0.0401606426,10.6974623 C0.0401606426,10.6974623 0.0401606426,10.6974623 0.0401606426,10.7176844 C0.120481928,11.7692308 0.301204819,12.7196669 0.582329317,13.609437 C0.963855422,14.7823156 1.52610442,15.7934179 2.24899598,16.6225218 C2.97188755,17.4516257 3.85542169,18.0987312 4.87951807,18.5436162 C5.90361446,18.9885012 7.04819277,19.2109437 8.33333333,19.2109437 C9.53815261,19.2109437 10.6024096,19.0491673 11.5261044,18.7053925 C11.9678715,18.5436162 12.3694779,18.3413957 12.751004,18.1189532 C12.8514056,18.0582871 12.9518072,17.9976209 13.0321285,17.9369548 C13.0522088,17.9369548 13.0522088,17.9167328 13.0722892,17.9167328 C13.2329317,17.7954005 13.3935743,17.6740682 13.5341365,17.5325139 C14.1164659,16.9056305 14.5783133,16.258525 14.939759,15.4900872 Z"
	logomark: "M32.7533512,0.382929927 L35.5844504,0.382929927 L35.5844504,15.3671445 L32.7533512,15.3671445 L32.7533512,0.382929927 L32.7533512,0.382929927 Z M45.7828418,5.52751025 C46.6032172,6.49315964 47.0053619,7.79179156 47.0053619,9.42340604 L47.0053619,10.6054941 L39.6702413,10.6054941 C39.7024129,11.4878978 39.9115282,12.170512 40.3136729,12.6699859 C40.7158177,13.1694597 41.3270777,13.4191966 42.1313673,13.4191966 C43.2573727,13.4191966 43.9168901,12.9363719 44.1260054,11.9540734 L46.8766756,11.9540734 C46.6836461,13.1861088 46.2171582,14.1184599 45.4450402,14.7511268 C44.689008,15.3837936 43.5630027,15.700127 42.1152815,15.700127 C40.3619303,15.700127 39.0428954,15.2006532 38.1581769,14.1850564 C37.2734584,13.1861088 36.8230563,11.7542839 36.8230563,9.90623073 C36.8230563,8.99052873 36.9517426,8.15807236 37.2091153,7.44215989 C37.4664879,6.72624742 37.8203753,6.11022971 38.2868633,5.61075589 C38.7533512,5.11128207 39.3163539,4.72835215 39.9597855,4.46196611 C40.6032172,4.19558007 41.3270777,4.07903618 42.1152815,4.07903618 C43.7560322,4.07903618 44.9785523,4.56186087 45.7828418,5.52751025 L45.7828418,5.52751025 Z M44.2868633,8.67419531 C44.2868633,7.92498458 44.1099196,7.325616 43.7560322,6.90938782 C43.4021448,6.49315964 42.8391421,6.27672098 42.0831099,6.27672098 C41.6970509,6.27672098 41.3753351,6.34331749 41.0857909,6.45986138 C40.7962466,6.5930544 40.5549598,6.75954567 40.3619303,6.97598433 C40.1689008,7.19242298 40.0080429,7.44215989 39.9115282,7.72519505 C39.7989276,8.00823022 39.7345845,8.32456364 39.7345845,8.65754618 L44.2868633,8.65754618 L44.2868633,8.67419531 Z M57.3646113,6.62635265 C57.5254692,7.15912473 57.5898123,7.77514244 57.5898123,8.44110753 L57.5898123,15.3671445 L54.919571,15.3671445 L54.919571,13.9852669 C54.5013405,14.4680916 54.0348525,14.8676707 53.5040214,15.1840041 C52.9892761,15.4836884 52.3136729,15.6501796 51.4932976,15.6501796 C51.0268097,15.6501796 50.5764075,15.5835831 50.1420912,15.4670392 C49.7238606,15.3338462 49.3378016,15.1507058 49.0321716,14.8843198 C48.7104558,14.6179337 48.4530831,14.2849512 48.2761394,13.868723 C48.0831099,13.4524948 47.9865952,12.9696701 47.9865952,12.3869507 C47.9865952,11.63774 48.1474531,11.0217223 48.4691689,10.5388976 C48.7908847,10.0560729 49.2252011,9.68979207 49.7399464,9.42340604 C50.2707775,9.15702 50.8659517,8.9738796 51.5093834,8.85733571 C52.1689008,8.74079182 52.8284182,8.67419531 53.5040214,8.64089705 L54.8552279,8.57430055 L54.8552279,8.02487935 C54.8552279,7.35891425 54.6782842,6.89273869 54.3243968,6.64300178 C53.9705094,6.39326487 53.536193,6.26007185 53.0536193,6.26007185 C51.9276139,6.26007185 51.2841823,6.69294916 51.1233244,7.57535291 L48.5335121,7.325616 C48.7265416,6.17682622 49.2091153,5.34436985 49.997319,4.84489604 C50.7855228,4.32877309 51.8310992,4.07903618 53.1662198,4.07903618 C53.9705094,4.07903618 54.6621984,4.17893095 55.2412869,4.37872047 C55.8042895,4.57851 56.2707775,4.87819429 56.6085791,5.24447509 C56.9624665,5.62740502 57.2037534,6.09358058 57.3646113,6.62635265 L57.3646113,6.62635265 Z M54.8552279,10.4723011 L53.6005362,10.5388976 C53.0053619,10.5721958 52.5227882,10.6221432 52.1689008,10.722038 C51.7989276,10.8219327 51.5254692,10.9384766 51.3324397,11.0883188 C51.1394102,11.2381609 51.0107239,11.4046522 50.9302949,11.6044417 C50.8659517,11.8042312 50.8337802,12.0206699 50.8337802,12.2537577 C50.8337802,12.6200385 50.9624665,12.9030736 51.2037534,13.1195123 C51.4450402,13.3359509 51.7828418,13.4358457 52.2171582,13.4358457 C52.9410188,13.4358457 53.536193,13.2527053 54.002681,12.9030736 C54.2600536,12.7032841 54.4691689,12.4535472 54.6300268,12.1538629 C54.7908847,11.8541786 54.8713137,11.4712487 54.8713137,11.0383714 L54.8713137,10.4723011 L54.8552279,10.4723011 Z M64.7640751,4.22887833 C64.2171582,4.22887833 63.6863271,4.37872047 63.1876676,4.66175564 C62.689008,4.9447908 62.2546917,5.37766811 61.9168901,5.96038756 L61.9168901,4.41201873 L59.1662198,4.41201873 L59.1662198,15.3671445 L61.997319,15.3671445 L61.997319,9.02382698 C61.997319,8.72414269 62.0616622,8.44110753 62.1742627,8.15807236 C62.2868633,7.8750372 62.463807,7.62530029 62.7050938,7.40886164 C62.9302949,7.19242298 63.1876676,7.05922996 63.4772118,6.97598433 C63.766756,6.89273869 64.0563003,6.85944044 64.3619303,6.85944044 C64.8284182,6.85944044 65.230563,6.90938782 65.5522788,6.99263345 L65.8900804,4.32877309 C65.7613941,4.29547484 65.6005362,4.27882571 65.4235925,4.26217658 C65.2466488,4.22887833 65.0214477,4.22887833 64.7640751,4.22887833 L64.7640751,4.22887833 Z M74.077748,6.49315964 L72.0831099,6.09358058 C71.3592493,5.94373844 70.8284182,5.72729978 70.538874,5.44426462 C70.233244,5.16122945 70.0884718,4.74500127 70.0884718,4.17893095 C70.0884718,3.96249229 70.1367292,3.76270276 70.2171582,3.56291324 C70.2975871,3.36312371 70.4423592,3.19663244 70.6353887,3.04679029 C70.844504,2.89694815 71.1018767,2.78040425 71.4396783,2.69715862 C71.7774799,2.61391298 72.1957105,2.5639656 72.7104558,2.5639656 C73.5790885,2.5639656 74.2225201,2.747106 74.6407507,3.1133868 C75.0589812,3.4796676 75.3485255,4.07903618 75.5093834,4.89484342 L78.3726542,4.51191349 C78.308311,3.92919404 78.1635389,3.36312371 77.9544236,2.81370251 C77.7453083,2.26428131 77.4235925,1.78145662 76.9892761,1.38187756 C76.5549598,0.965649382 75.9919571,0.632666836 75.2841823,0.382929927 C74.5764075,0.133193018 73.7077748,-2.66453526e-15 72.6461126,-2.66453526e-15 C71.8257373,-2.66453526e-15 71.0697051,0.0998947636 70.3780161,0.283035164 C69.6863271,0.466175564 69.0911528,0.749210727 68.6085791,1.11549153 C68.1099196,1.48177233 67.7238606,1.93129876 67.4504021,2.48071996 C67.1769437,3.03014116 67.0321716,3.662808 67.0321716,4.36207135 C67.0321716,5.07798382 67.1286863,5.69400153 67.3378016,6.21012447 C67.5469169,6.72624742 67.8364611,7.15912473 68.2225201,7.52540553 C68.6085791,7.8750372 69.0911528,8.17472149 69.6541555,8.39116015 C70.2171582,8.6075988 70.8766756,8.7907392 71.616622,8.94058135 L73.4986595,9.29021302 C74.2546917,9.44005516 74.769437,9.68979207 75.0589812,10.0394237 C75.3485255,10.3890554 75.4772118,10.7553362 75.4772118,11.1382661 C75.4772118,11.4213013 75.4289544,11.6710382 75.3485255,11.9207751 C75.2680965,12.1538629 75.1233244,12.3703016 74.9142091,12.5367928 C74.7050938,12.7199332 74.4477212,12.8531263 74.1260054,12.953021 C73.8042895,13.0529158 73.4021448,13.1028632 72.9356568,13.1028632 C71.9544236,13.1028632 71.1983914,12.8864245 70.6997319,12.4701963 C70.1849866,12.0539681 69.9115282,11.3713539 69.8310992,10.4556519 L66.7747989,10.4556519 C66.8552279,12.2204594 67.4182306,13.5357405 68.463807,14.4181442 C69.5093834,15.300548 71.0214477,15.7334253 73,15.7334253 C73.9490617,15.7334253 74.769437,15.6168814 75.4772118,15.3837936 C76.1849866,15.1507058 76.7640751,14.8343724 77.230563,14.4181442 C77.6970509,14.001916 78.0509383,13.5190913 78.2922252,12.9696701 C78.5335121,12.4202489 78.6461126,11.8042312 78.6461126,11.1549153 C78.6461126,9.78968684 78.2761394,8.75744095 77.5522788,8.04152847 C76.7962466,7.325616 75.6380697,6.80949305 74.077748,6.49315964 L74.077748,6.49315964 Z M86.1099196,12.8531263 C85.8042895,13.1861088 85.3538874,13.3526001 84.7908847,13.3526001 C84.3565684,13.3526001 84.002681,13.2527053 83.7131367,13.0695649 C83.4235925,12.8864245 83.1983914,12.6200385 83.0375335,12.3037051 C82.8766756,11.9873716 82.7640751,11.6044417 82.6997319,11.1882135 C82.6353887,10.7719853 82.6032172,10.3224589 82.6032172,9.87293247 C82.6032172,9.42340604 82.6353887,8.99052873 82.6997319,8.57430055 C82.7640751,8.15807236 82.8927614,7.79179156 83.0536193,7.47545815 C83.230563,7.15912473 83.4557641,6.89273869 83.7292225,6.70959829 C84.0187668,6.52645789 84.3726542,6.42656313 84.8069705,6.42656313 C85.4021448,6.42656313 85.8203753,6.5930544 86.0616622,6.94268607 C86.3029491,7.29231775 86.463807,7.74184418 86.5281501,8.29126538 L89.3914209,7.89168633 C89.3270777,7.325616 89.1823056,6.82614218 88.9892761,6.34331749 C88.7801609,5.87714193 88.5067024,5.47756287 88.1367292,5.14458033 C87.766756,4.81159778 87.3163539,4.54521175 86.7855228,4.36207135 C86.2546917,4.17893095 85.6273458,4.07903618 84.9034853,4.07903618 C84.0670241,4.07903618 83.3270777,4.2122292 82.6675603,4.49526436 C82.0241287,4.77829953 81.4772118,5.17787858 81.0268097,5.6773524 C80.5764075,6.19347535 80.2386059,6.80949305 79.997319,7.52540553 C79.7560322,8.241318 79.6434316,9.04047611 79.6434316,9.90623073 C79.6434316,10.7719853 79.7399464,11.5711435 79.9490617,12.2704068 C80.1581769,12.9863193 80.463807,13.5856879 80.8659517,14.1018108 C81.2841823,14.6012846 81.8150134,15.0008637 82.458445,15.2838988 C83.1018767,15.566934 83.8739946,15.700127 84.7747989,15.700127 C86.3029491,15.700127 87.4450402,15.3171971 88.2171582,14.5346881 C88.9731903,13.7521791 89.4235925,12.7199332 89.5201072,11.4046522 L86.6407507,11.4046522 C86.6085791,12.037319 86.4155496,12.5201437 86.1099196,12.8531263 L86.1099196,12.8531263 Z M101.150134,9.87293247 C101.150134,10.7886345 101.021448,11.6044417 100.780161,12.3203542 C100.522788,13.0362667 100.168901,13.6522844 99.7024129,14.1517582 C99.2359249,14.651232 98.6729223,15.0341619 98.0134048,15.300548 C97.3538874,15.566934 96.613941,15.700127 95.8096515,15.700127 C94.1045576,15.700127 92.7855228,15.2006532 91.8525469,14.1850564 C90.919571,13.1861088 90.4530831,11.7376347 90.4530831,9.85628335 C90.4530831,8.95723047 90.5817694,8.15807236 90.8230563,7.42551076 C91.080429,6.70959829 91.4343164,6.09358058 91.9008043,5.59410676 C92.3672922,5.09463295 92.9302949,4.71170302 93.5898123,4.44531698 C94.2493298,4.17893095 94.9892761,4.04573793 95.7935657,4.04573793 C96.613941,4.04573793 97.3538874,4.17893095 98.0294906,4.44531698 C98.689008,4.71170302 99.2520107,5.09463295 99.7184987,5.59410676 C100.184987,6.09358058 100.538874,6.69294916 100.780161,7.42551076 C101.021448,8.15807236 101.150134,8.9738796 101.150134,9.87293247 L101.150134,9.87293247 Z M98.2064343,9.87293247 C98.2064343,8.75744095 98.0134048,7.90833545 97.6112601,7.30896687 C97.2091153,6.72624742 96.613941,6.42656313 95.7935657,6.42656313 C94.9892761,6.42656313 94.3780161,6.72624742 93.9758713,7.30896687 C93.5737265,7.89168633 93.3806971,8.75744095 93.3806971,9.87293247 C93.3806971,11.0050731 93.5737265,11.8708277 93.9758713,12.4701963 C94.3619303,13.0695649 94.9731903,13.3692492 95.7935657,13.3692492 C96.5978552,13.3692492 97.2091153,13.0695649 97.6112601,12.4701963 C98.0134048,11.8541786 98.2064343,10.988424 98.2064343,9.87293247 L98.2064343,9.87293247 Z M108.002681,4.22887833 C107.455764,4.22887833 106.924933,4.37872047 106.426273,4.66175564 C105.927614,4.9447908 105.493298,5.37766811 105.155496,5.96038756 L105.155496,4.41201873 L102.404826,4.41201873 L102.404826,15.3671445 L105.219839,15.3671445 L105.219839,9.02382698 C105.219839,8.72414269 105.284182,8.44110753 105.396783,8.15807236 C105.509383,7.8750372 105.686327,7.62530029 105.927614,7.40886164 C106.152815,7.19242298 106.410188,7.05922996 106.699732,6.97598433 C106.989276,6.89273869 107.27882,6.85944044 107.58445,6.85944044 C108.050938,6.85944044 108.453083,6.90938782 108.774799,6.99263345 L109.112601,4.32877309 C108.983914,4.29547484 108.823056,4.27882571 108.646113,4.26217658 C108.50134,4.22887833 108.276139,4.22887833 108.002681,4.22887833 L108.002681,4.22887833 Z M119.487936,10.6054941 L112.136729,10.6054941 C112.168901,11.4878978 112.378016,12.170512 112.780161,12.6699859 C113.182306,13.1694597 113.793566,13.4191966 114.597855,13.4191966 C115.723861,13.4191966 116.383378,12.9363719 116.592493,11.9540734 L119.343164,11.9540734 C119.150134,13.1861088 118.683646,14.1184599 117.911528,14.7511268 C117.155496,15.3837936 116.029491,15.700127 114.581769,15.700127 C112.828418,15.700127 111.509383,15.2006532 110.624665,14.1850564 C109.739946,13.1861088 109.289544,11.7542839 109.289544,9.90623073 C109.289544,8.99052873 109.418231,8.15807236 109.675603,7.44215989 C109.932976,6.72624742 110.286863,6.11022971 110.753351,5.61075589 C111.219839,5.11128207 111.782842,4.72835215 112.426273,4.46196611 C113.069705,4.19558007 113.793566,4.07903618 114.581769,4.07903618 C116.206434,4.07903618 117.428954,4.56186087 118.24933,5.52751025 C119.069705,6.49315964 119.47185,7.79179156 119.47185,9.42340604 L119.47185,10.6054941 L119.487936,10.6054941 Z M116.753351,8.67419531 C116.753351,7.92498458 116.576408,7.325616 116.22252,6.90938782 C115.868633,6.49315964 115.30563,6.27672098 114.549598,6.27672098 C114.163539,6.27672098 113.841823,6.34331749 113.552279,6.45986138 C113.262735,6.5930544 113.021448,6.75954567 112.828418,6.97598433 C112.635389,7.19242298 112.474531,7.44215989 112.378016,7.72519505 C112.265416,8.00823022 112.201072,8.32456364 112.201072,8.65754618 L116.753351,8.65754618 L116.753351,8.67419531 Z M30.9678284,12.7365824 C30.6782842,13.3692492 30.308311,13.9186704 29.8418231,14.4181442 C29.7292225,14.5346881 29.6005362,14.6345829 29.4718499,14.7344776 C29.4557641,14.7344776 29.4557641,14.7511268 29.4396783,14.7511268 C29.3753351,14.8010741 29.2949062,14.8510215 29.2144772,14.9009689 C28.9088472,15.0841093 28.5871314,15.2506006 28.233244,15.3837936 C27.4932976,15.6668288 26.6407507,15.8000218 25.6756032,15.8000218 C24.6461126,15.8000218 23.7292225,15.6168814 22.9088472,15.2506006 C22.0884718,14.8843198 21.3806971,14.3515477 20.8016086,13.6689335 C20.2225201,12.9863193 19.772118,12.1538629 19.4664879,11.1882135 C19.2412869,10.4556519 19.0965147,9.67314295 19.0321716,8.80738833 C19.0321716,8.7907392 19.0321716,8.7907392 19.0321716,8.7907392 C19.0160858,8.50770404 19,8.20801975 19,7.90833545 C19,7.60865116 19.0160858,7.30896687 19.0321716,7.02593171 C19.0321716,7.00928258 19.0321716,7.00928258 19.0321716,7.00928258 C19.0965147,6.14352796 19.2412869,5.34436985 19.4664879,4.62845738 C19.772118,3.662808 20.2225201,2.83035164 20.8016086,2.14773742 C21.3806971,1.44847407 22.0884718,0.932351127 22.9088472,0.566070327 C23.7131367,0.199789527 24.6461126,0.0166491273 25.6756032,0.0166491273 C26.6568365,0.0166491273 27.4932976,0.149842145 28.233244,0.432877309 C28.5871314,0.566070327 28.9088472,0.7325616 29.2144772,0.915702 C29.2949062,0.965649382 29.3592493,1.01559676 29.4396783,1.06554415 C29.4557641,1.06554415 29.4557641,1.08219327 29.4718499,1.08219327 C29.6005362,1.18208804 29.7292225,1.2819828 29.8418231,1.39852669 C30.308311,1.84805313 30.6782842,2.3808252 30.9678284,3.01349204 C31.1447721,3.42972022 31.2895442,3.86259753 31.4182306,4.32877309 L28.5710456,5.42761549 C28.5710456,5.41096636 28.5710456,5.41096636 28.5710456,5.41096636 C28.4423592,4.57851 28.1849866,3.91254491 27.766756,3.44636935 C27.3324397,2.94689553 26.6407507,2.69715862 25.7077748,2.69715862 C24.5335121,2.69715862 23.6487936,3.14668505 23.0536193,4.04573793 C22.458445,4.9447908 22.152815,6.2267736 22.152815,7.8750372 C22.152815,9.5233008 22.458445,10.8052836 23.0536193,11.7043365 C23.6648794,12.6033893 24.5495979,13.0529158 25.7077748,13.0529158 C26.6407507,13.0529158 27.3324397,12.8031789 27.766756,12.3037051 C28.1849866,11.8375295 28.458445,11.1882135 28.5710456,10.339108 C28.5710456,10.3224589 28.5710456,10.3224589 28.5710456,10.3224589 L31.4182306,11.4213013 C31.2895442,11.8874769 31.1447721,12.3370033 30.9678284,12.7365824 Z M2.04289544,15.6335305 C0.91689008,15.6335305 0,14.6845303 0,13.5190913 C0,12.3536524 0.91689008,11.4046522 2.04289544,11.4046522 C3.1689008,11.4046522 4.08579088,12.3536524 4.08579088,13.5190913 C4.06970509,14.6845303 3.1689008,15.6335305 2.04289544,15.6335305 Z M15.0723861,15.0008637 L15.0723861,15.0008637 L8.07506702,15.0008637 L8.07506702,12.0040208 L12.1769437,12.0040208 L12.1769437,2.99684291 L3.47453083,2.99684291 L3.47453083,7.22572124 L0.579088472,7.22572124 L0.579088472,2.66453526e-15 L15.0723861,2.66453526e-15 L15.0723861,15.0008637 Z"