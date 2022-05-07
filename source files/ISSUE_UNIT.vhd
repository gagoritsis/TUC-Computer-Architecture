----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:40 04/15/2021 
-- Design Name: 
-- Module Name:    ISSUE_UNIT - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ISSUE_UNIT is
    Port ( CLK : in STD_LOGIC;
			  Issue : in  STD_LOGIC;
           FU_type : in  STD_LOGIC_VECTOR (1 downto 0);
           Fop : in  STD_LOGIC_VECTOR (1 downto 0);
           Ri : in  STD_LOGIC_VECTOR (4 downto 0);
           Rj : in  STD_LOGIC_VECTOR (4 downto 0);
           Rk : in  STD_LOGIC_VECTOR (4 downto 0);
			  RS_Logic_Avail : in STD_LOGIC_VECTOR(1 downto 0); --00 not avail, 01 RS1 avail, 10 RS2 avail, 11 all avail
			  RS_Arith_Avail :in STD_LOGIC_VECTOR(2 downto 0); --000 not avail, 001 RS1 av, 010 RS2 av, 011 RS1 &RS2 av, 100 RS3 av, 101 RS1 & RS3 av, 110 RS3 & RS2 av, 111 all av
			  Ri_out : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
           Rj_out : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
           Rk_out : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
			  RS_tag : out  STD_LOGIC_VECTOR (4 downto 0); --to RF
			  Op_to_RS : out STD_LOGIC_VECTOR (1 downto 0); --to RS
			  Issue_Logic : out STD_LOGIC; --to RS_FU_CTRL
			  Issue_Arith : out STD_LOGIC; --to RS_FU_CTRL
           Accepted : out  STD_LOGIC);
end ISSUE_UNIT;

architecture Behavioral of ISSUE_UNIT is

signal temp_accepted: std_logic;
signal temp_Ri: std_logic_vector(4 downto 0);
signal temp_Rj: std_logic_vector(4 downto 0);
signal temp_Rk: std_logic_vector(4 downto 0);
signal temp_RS_tag: std_logic_vector(4 downto 0);
signal temp_issue_logic : std_logic;
signal temp_issue_arith : std_logic;
signal temp_op_out : std_logic_vector(1 downto 0);

begin

process
begin
wait until CLK'EVENT AND CLK='1';
		if Issue='1' then --if there is an instruction to issue
			if (FU_type="00" and (RS_Logic_Avail="01" or RS_Logic_Avail="11")) then
				temp_accepted<='1';
				temp_Ri<=Ri;
				temp_Rj<=Rj;  
				temp_Rk<=Rk;
				temp_op_out<=Fop;
				temp_issue_logic<='1';
				temp_issue_arith<='0';
				temp_RS_tag<="10001";
			
			elsif (FU_type="00" and RS_Logic_Avail="10") then
				temp_accepted<='1';
				temp_Ri<=Ri;
				temp_Rj<=Rj;
				temp_Rk<=Rk;
				temp_op_out<=Fop;
				temp_issue_logic<='1';
				temp_issue_arith<='0';
				temp_RS_tag<="10010";

				
			elsif (FU_type="01" and (RS_Arith_Avail="001" or RS_Arith_Avail="011" or RS_Arith_Avail="101" or RS_Arith_Avail="111")) then
				temp_accepted<='1';
				temp_Ri<=Ri;
				temp_Rj<=Rj;
				temp_Rk<=Rk;
				temp_op_out<=Fop;
				temp_issue_logic<='0';
				temp_issue_arith<='1';
				temp_RS_tag<="01001";

				
			elsif (FU_type="01" and (RS_Arith_Avail="010" or RS_Arith_Avail="110")) then
				temp_accepted<='1';
				temp_Ri<=Ri;
				temp_Rj<=Rj;
				temp_Rk<=Rk;
				temp_op_out<=Fop;
				temp_issue_logic<='0';
				temp_issue_arith<='1';
				temp_RS_tag<="01010";
				
			elsif FU_type="01" and RS_Arith_Avail="100" then
				temp_accepted<='1';
				temp_Ri<=Ri;
				temp_Rj<=Rj;
				temp_Rk<=Rk;
				temp_op_out<=Fop;
				temp_issue_logic<='0';
				temp_issue_arith<='1';	
				temp_RS_tag<="01011";

			else
				temp_Ri<="00000";
				temp_Rj<="00000";
				temp_Rk<="00000";
				temp_accepted<='0';
				temp_op_out<="00";
				temp_issue_logic<='0';
				temp_issue_arith<='0';

			end if;
		
		else
			temp_Ri<="00000";
			temp_Rj<="00000";
			temp_Rk<="00000";
			temp_accepted<='0';
			temp_op_out<="00";
			temp_issue_logic<='0';
			temp_issue_arith<='0';

		end if;
end process;

Accepted<=temp_accepted; --to RS control & RF maybe
Ri_out<=temp_Ri; --to RF
Rj_out<=temp_Rj; --to RF
Rk_out<=temp_Rk; --to RF
Issue_Logic<=temp_issue_logic; --to RS control
Issue_Arith<=temp_issue_arith; --to RS control
RS_tag<=temp_RS_tag; --to RF
Op_to_RS<=temp_op_out; --to RS

end Behavioral;

