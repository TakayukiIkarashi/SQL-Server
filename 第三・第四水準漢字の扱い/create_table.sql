/* �����e�[�u�� */
CREATE TABLE tbl_moji (
    moji NVARCHAR(2) NOT NULL -- ����
  , jis VARCHAR(4) NOT NULL -- JIS�R�[�h
  , kuten VARCHAR(6) -- ��_�R�[�h
  , high_level SMALLINT NOT NULL -- �������t���O
  , PRIMARY KEY (kuten)
);
