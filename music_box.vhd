LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY music_box IS PORT (
    CLK50MHZ: IN  STD_LOGIC;
    SW: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    LEDR: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    GPIO: OUT STD_LOGIC_VECTOR(36 DOWNTO 0)
);
END ENTITY;


ARCHITECTURE behaviour OF music_box IS
SIGNAL   CLK_DVDE : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL        CNT : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL       TONE : STD_LOGIC_VECTOR(22 DOWNTO 0);
SIGNAL    CLK_ALM : STD_LOGIC;
SIGNAL   CLK25MHZ : STD_LOGIC;
SIGNAL       RAMP : STD_LOGIC_VECTOR(6 DOWNTO 0);

SIGNAL    CLK_ALM_2 : STD_LOGIC;
CONSTANT CLK_DVDE_2 : INTEGER := 56818;
SIGNAL        COUNT : INTEGER RANGE 0 TO 65536;
SIGNAL       TONE_2 : STD_LOGIC_VECTOR(24 DOWNTO 0);

SIGNAL    CLK_ALM_3 : STD_LOGIC;
SIGNAL       CHOICE : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL   CLK_DVDE_3 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL      COUNT_3 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL       TONE_3 : STD_LOGIC_VECTOR(27 DOWNTO 0);
SIGNAL FST_SWP, SLW_SWP: STD_LOGIC_VECTOR(6 DOWNTO 0);

SIGNAL    CLK_ALM_4 : STD_LOGIC;
CONSTANT CLK_DVDE_4 : INTEGER := 56818;
SIGNAL      COUNT_4 : INTEGER RANGE 0 TO 65536;
SIGNAL       TONE_4 : STD_LOGIC_VECTOR(24 DOWNTO 0);

BEGIN

-- GPIO(5) <= CLK_ALM;
LEDR(9 DOWNTO 4) <= "000000";
DISP_CLK_1: WORK.clk_25  PORT MAP(INCLK0 => CLK50MHZ, C0 => CLK25MHZ);

PROCESS(CLK25MHZ, TONE, TONE_2, TONE_3, TONE_4, CNT, RAMP, CLK50MHZ, FST_SWP, SLW_SWP, CHOICE)

	BEGIN

	IF SW(3 DOWNTO 0) = "0001" THEN
	    LEDR(3 DOWNTO 0) <= "0001";
		GPIO(5) <= CLK_ALM;

		IF TONE(22) = '1' THEN
			RAMP <= TONE(21 DOWNTO 15);
		ELSE
			RAMP <= NOT(TONE(21 DOWNTO 15));
		END IF;

		CLK_DVDE <= "01" & RAMP & "000000";

		IF RISING_EDGE(CLK25MHZ) THEN
			TONE <= TONE + '1';
		END IF;

		IF RISING_EDGE(CLK25MHZ) THEN
			IF CNT = "0000000000000000" THEN
				CNT <= CLK_DVDE;
			ELSE
				CNT <= CNT - 1;
			END IF;
		END IF;

		IF RISING_EDGE(CLK25MHZ) THEN
			IF CNT = 0 THEN
				CLK_ALM <= NOT(CLK_ALM);
			END IF;
		END IF;

	ELSIF  SW(3 DOWNTO 0) = "0010" THEN
		LEDR(3 DOWNTO 0) <= "0010";
		GPIO(5) <= CLK_ALM_2;

		IF RISING_EDGE(CLK50MHZ) THEN
			TONE_2 <= TONE_2 + '1';
		END IF;

		IF RISING_EDGE(CLK50MHZ) THEN
			IF COUNT = 0 THEN
				IF TONE_2(24) = '1' THEN
					COUNT <= CLK_DVDE_2 - 1;
				ELSE
					COUNT <= (CLK_DVDE_2/2) - 1;
				END IF;
			ELSE
				COUNT <= COUNT - 1;
			END IF;
		END IF;

		IF RISING_EDGE(CLK50MHZ) THEN
			IF COUNT = 0 THEN
				CLK_ALM_2 <= NOT(CLK_ALM_2);
			END IF;
		END IF;

	ELSIF  SW(3 DOWNTO 0) = "0100" THEN
		LEDR(3 DOWNTO 0) <= "0100";
		GPIO(5) <= CLK_ALM_3;

		IF TONE_3(22) = '1' THEN
			FST_SWP <= TONE_3(21 DOWNTO 15);
		ELSE
			FST_SWP <= NOT(TONE_3(21 DOWNTO 15));
		END IF;

		IF TONE_3(25) = '1' THEN
			SLW_SWP <= TONE_3(24 DOWNTO 18);
		ELSE
			SLW_SWP <= NOT(TONE_3(24 DOWNTO 18));
		END IF;

		IF TONE_3(27) = '1' THEN
			CHOICE <= SLW_SWP;
		ELSE
			CHOICE <= FST_SWP;
		END IF;

		CLK_DVDE_3 <= "01" & CHOICE & "000000";

		IF RISING_EDGE(CLK25MHZ) THEN
			TONE_3 <= TONE_3 + '1';
		END IF;

		IF RISING_EDGE(CLK25MHZ) THEN
			IF COUNT_3 = "0000000000000000" THEN
				COUNT_3 <= CLK_DVDE_3;
			ELSE
				COUNT_3 <= COUNT_3 - 1;
			END IF;
		END IF;

		IF RISING_EDGE(CLK25MHZ) THEN
			IF COUNT_3 = 0 THEN
				CLK_ALM_3 <= NOT(CLK_ALM_3);
			END IF;
		END IF;


	ELSIF  SW(3 DOWNTO 0) = "1000" THEN
		LEDR(3 DOWNTO 0) <= "1000";
		GPIO(5) <= CLK_ALM_4;

		IF RISING_EDGE(CLK50MHZ) THEN
			TONE_4 <= TONE_4 + '1';
		END IF;

		IF RISING_EDGE(CLK50MHZ) THEN
			IF COUNT = 0 THEN
				IF TONE_4(24) = '1' THEN
					COUNT_4 <= CLK_DVDE_4 - 1;
				ELSE
					COUNT_4 <= (CLK_DVDE_4/2) - 1;
				END IF;
			ELSE
				COUNT_4 <= COUNT_4 - 1;
			END IF;
		END IF;

		IF RISING_EDGE(CLK50MHZ) THEN
			IF COUNT_4 = 0 THEN
				CLK_ALM_4 <= NOT(CLK_ALM_4);
			END IF;
		END IF;
	ELSE
		LEDR(3 DOWNTO 0) <= "0000";
	END IF;

END PROCESS;
END ARCHITECTURE;