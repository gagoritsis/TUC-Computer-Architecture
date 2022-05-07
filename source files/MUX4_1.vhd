----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:42:41 07/04/2021 
-- Design Name: 
-- Module Name:    MUX2_1 - Behavioral 
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

entity MUX4_1 is
    Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
			  datain0 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  datain2 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain3 : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX4_1;

architecture Behavioral of MUX4_1 is

signal tempOut: std_logic_vector(31 downto 0);

begin
process(sel,datain0, datain1, datain2, datain3,tempOut)
begin
	if(sel(1 downto 0) = "00") then 
	    tempOut<=datain0;
	elsif (sel(1 downto 0) = "01") then
	    tempOut<=datain1;
	elsif (sel(1 downto 0) = "10") then
	    tempOut<=datain2;
	else
	    tempOut<=datain3;
	end if;
	
end process;
dataout<=tempOut;
end Behavioral;

