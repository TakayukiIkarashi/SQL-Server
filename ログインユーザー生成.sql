-- [master]�f�[�^�x�[�X�ɐڑ����܂�
USE master;

-- SQL Server�ɐڑ����邽�߂̃��O�C���A�J�E���g[hoge_login]�𐶐����܂�
CREATE LOGIN hoge_login WITH PASSWORD = '[�����Ƀp�X���[�h���w��]';

-- [hoge]�f�[�^�ׁ[�X�ɐڑ����܂�
USE hoge;

-- SQL Server�Ƀ��[�U�[[hoge_user]�𐶐����A��قǐ����������O�C���A�J�E���g[hoge_login]�ɕR�Â��܂�
CREATE USER hoge_user FROM LOGIN hoge_login;

-- �����������[�U�[[hoge_user]�ɁA[hoge]�̃f�[�^�x�[�X���L�Ҍ�����^���܂�
ALTER ROLE db_owner ADD MEMBER hoge_user;
