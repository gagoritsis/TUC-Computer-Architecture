--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:18:22 04/25/2021
-- Design Name:   
-- Module Name:   C:/Users/georg/Desktop/HMMY/10.Semester 8/Computer Architecture/Project/Tomasulo_1/TOMASULO_PROC_TEST.vhd
-- Project Name:  Tomasulo_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TOMASULO_PROC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TOMASULO_PROC_TEST IS
END TOMASULO_PROC_TEST;
 
ARCHITECTURE behavior OF TOMASULO_PROC_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOMASULO_PROC
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Issue : IN  std_logic;
         FU_type : IN  std_logic_vector(1 downto 0);
         Fop : IN  std_logic_vector(1 downto 0);
         Ri : IN  std_logic_vector(4 downto 0);
         Rj : IN  std_logic_vector(4 downto 0);
         Rk : IN  std_logic_vector(4 downto 0);
         Accepted : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal Issue : std_logic := '0';
   signal FU_type : std_logic_vector(1 downto 0) := (others => '0');
   signal Fop : std_logic_vector(1 downto 0) := (others => '0');
   signal Ri : std_logic_vector(4 downto 0) := (others => '0');
   signal Rj : std_logic_vector(4 downto 0) := (others => '0');
   signal Rk : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal Accepted : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOMASULO_PROC PORT MAP (
          CLK => CLK,
          RST => RST,
          Issue => Issue,
          FU_type => FU_type,
          Fop => Fop,
          Ri => Ri,
          Rj => Rj,
          Rk => Rk,
          Accepted => Accepted
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
---------------------------------------------------------------------
	--testing - part 1
---------------------------------------------------------------------

      -- hold reset state for 100 ns.
--		RST<='1';
--      wait for 100 ns;	
--		--one by one
--		RST<='0';
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00001";
--		Rj<="00010";
--		Rk<="00011";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*4;
--		
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="01"; --add
--		Ri<="00010";
--		Rj<="00001";
--		Rk<="00011";
--		wait for CLK_period;
--
--		Issue<='0';
--		wait for CLK_period*5;		
--		
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00011";
--		Rj<="00000";
--		Rk<="00000";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*4;	
--
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="00"; --or
--		Ri<="00100";
--		Rj<="00011";
--		Rk<="00000";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*4;
--		
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="00"; --add
--		Ri<="00101";
--		Rj<="00000";
--		Rk<="00000";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*5;
--		
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="01"; --sub
--		Ri<="00110";
--		Rj<="00100";
--		Rk<="00101";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*5;
--		
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="10"; --sll
--		Ri<="00111";
--		Rj<="00011";
--		Rk<="00101";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*5;

--------------------------------------------------------------
-- testing - part 2
--------------------------------------------------------------
	
		-- hold reset state for 100 ns.
--      RST<='1';
--      wait for 100 ns;	
--		
--		--initialize register 1 and 2
--		RST<='0';
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00001";
--		Rj<="00010";
--		Rk<="00011";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*5;
--		
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="01"; --add
--		Ri<="00010";
--		Rj<="00001";
--		Rk<="00011";
--		wait for CLK_period;
--
--		Issue<='0';
--		wait for CLK_period*5;	
--		
--		--test a logic and arith instr issued one after another: not x3 x0 x1 & sll x4 x1 x0 
--		--if we test the opposite then both results will be available at the same clk cycle
----		Issue<='1';
----		FU_type<="00"; --logic
----		Fop<="10"; --not
----		Ri<="00011";
----		Rj<="00000";
----		Rk<="00001";
----      wait for CLK_period;
----				
----		Issue<='1';
----		FU_type<="01"; --arith
----		Fop<="10"; --sll
----		Ri<="00100";
----		Rj<="00001";
----		Rk<="00000";
----      wait for CLK_period;
----		
----		Issue<='0';
----		wait for CLK_period*4;
----		
----		--the opposite
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="10"; --sll
--		Ri<="00100";
--		Rj<="00001";
--		Rk<="00000";
--      wait for CLK_period;
--		
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00011";
--		Rj<="00000";
--		Rk<="00001";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*4;

---------------------------------------------------------------------
--	testing - part 3
---------------------------------------------------------------------

--		-- hold reset state for 100 ns.
--      RST<='1';
--      wait for 100 ns;	
--		
--		--initialization part 
--		--initialize register 1 and 2
--		RST<='0';
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00001";
--		Rj<="00010";
--		Rk<="00011";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*5;
--		
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="01"; --add
--		Ri<="00010";
--		Rj<="00001";
--		Rk<="00011";
--		wait for CLK_period;
--
--		Issue<='0';
--		wait for CLK_period*5;	
--		
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="00"; --or
--		Ri<="00011";
--		Rj<="00000";
--		Rk<="00000";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*5;
--
--
--		--main part - test 3
--		--test two arith instr issued one after another: add x4 x3 x3 & sll x5 x1 x0 
--
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="00"; --add
--		Ri<="00100";
--		Rj<="00011";
--		Rk<="00011";
--      wait for CLK_period;
--				
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="10"; --sll
--		Ri<="00101";
--		Rj<="00001";
--		Rk<="00000";
--      wait for CLK_period;
--		
--		--comment line 325 and 326 in order to use testing-part 4 and uncomment testing-part 4 part
--		Issue<='0';
--		wait for CLK_period*4;


------------------------------------------------------------------------------------------------
---- testing - part 4 -- also use testing - part 3 - comment line 325 and 326
------------------------------------------------------------------------------------------------

--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00110";
--		Rj<="00000";
--		Rk<="00001";
--		wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*4;

--------------------------------------------------------------------------		
-- testing - part 5
--------------------------------------------------------------------------

		-- hold reset state for 100 ns.
      RST<='1';
      wait for 100 ns;	
		
		--initialize register 1 and 2 and 3 
		RST<='0';
		Issue<='1';
		FU_type<="00"; --logic
		Fop<="10"; --not
		Ri<="00001";
		Rj<="00010";
		Rk<="00011";
      wait for CLK_period;
		
		Issue<='0';
		wait for CLK_period*5;
		
		Issue<='1';
		FU_type<="01"; --arith
		Fop<="01"; --add
		Ri<="00010";
		Rj<="00001";
		Rk<="00011";
		wait for CLK_period;

		Issue<='0';
		wait for CLK_period*5;	
		
		Issue<='1';
		FU_type<="00"; --logic
		Fop<="00"; --or
		Ri<="00011";
		Rj<="00000";
		Rk<="00000";
      wait for CLK_period;
		
		Issue<='0';
		wait for CLK_period*5;
		
		
		--main part - test 5
		--main testing: issue two arith instr and then issue three logic instr (the first two should expect result from the second arith instr)

		Issue<='1';
		FU_type<="01"; --arith
		Fop<="00"; --add
		Ri<="00100";
		Rj<="00011";
		Rk<="00011";
      wait for CLK_period;
				
		Issue<='1';
		FU_type<="01"; --arith
		Fop<="10"; --sll
		Ri<="00101";
		Rj<="00001";
		Rk<="00000";
      wait for CLK_period;
	
		Issue<='1';
		FU_type<="00"; --logic
		Fop<="10"; --not
		Ri<="00110";
		Rj<="00101";
		Rk<="00001";
		wait for CLK_period;
		
		Issue<='1';
		FU_type<="00"; --logic
		Fop<="10"; --not
		Ri<="00111";
		Rj<="00101";
		Rk<="00000";
		wait for CLK_period;

		Issue<='1';
		FU_type<="00"; --logic
		Fop<="01"; --and
		Ri<="01000";
		Rj<="00101";
		Rk<="00100";
		wait for CLK_period*6; --we maintain issue=1 because logic and x8 x5 x3 was not accepted for the next 5 clk
				
		Issue<='0';
		wait for CLK_period*4;

--------------------------------------------------------------------------------------------		
-- testing - part 6 -- use initialization part of testing - part 5 - comment everything else
--------------------------------------------------------------------------------------------
--		Issue<='1';
--		FU_type<="01"; --arith
--		Fop<="00"; --add
--		Ri<="00100";
--		Rj<="00011";
--		Rk<="00011";
--      wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*3;
--		
--		Issue<='1';
--		FU_type<="00"; --logic
--		Fop<="10"; --not
--		Ri<="00101";
--		Rj<="00100";
--		Rk<="00000";
--		wait for CLK_period;
--		
--		Issue<='0';
--		wait for CLK_period*4;
		

      wait;
   end process;

END;
