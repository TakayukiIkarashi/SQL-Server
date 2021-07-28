/*
********************************************************************************
 �֐����Ffn_create_hash
 �T�v�@�F�����Ɏw�肳�ꂽ��������Í������ĕԂ��܂�
 �����@�F[@str]      ...�Í������镶����
 �@�@�@�@[@salt_base]...salt�̃x�[�X�ƂȂ镶����
 �߂�l�F�Í��������o�C�i��
********************************************************************************
*/
CREATE FUNCTION fn_create_hash
(
    @str VARCHAR(20)        --�Í������镶����
  , @salt_base VARCHAR(20)  --salt�̃x�[�X�ƂȂ镶����
)
RETURNS VARCHAR(100)
AS
BEGIN

    /*
    �Í����A���S���Y���́A���̂Ƃ���ł��B

        MD5([�Í������镶����] + salt)

    MD5()�́A�����̕������MD5�`���ňÍ�������֐��Ƃ��܂��B
    salt�l�́A���̃��W�b�N�Ő������܂��B

        HASHBYTES('MD5', 'gihyo')
    */

    RETURN UPPER(
        master.dbo.fn_varbintohexstr(
            HASHBYTES(
                'MD5', @str + UPPER(
                    master.dbo.fn_varbintohexstr(
                        HASHBYTES('MD5', @salt_base)
                    )
                )
            )
        )
    );
END
GO
