# プリミティブ

入試システムにおけるプリミティブなデータや列挙値を定義する.

## 年度および期

入試システムは複数の年度にわたって入試データや出願データを保持しつづけるため,いくつかのモデルは年度と期によって管理されている.

```alloy
sig 年度{
}
enum 入学期 { 春入学, 秋入学 }
```

## 学生の所属組織

学生の属する組織としての学部や学科などのレベルを表現する.

```alloy
sig 学部{
}
sig 課程{
}
sig 学科{
}
sig コース{
}
```

## 各種列挙値

上位のモデルで使用する列挙値を定義する.

### 年次

学生は通常一年次から四年次までしかとりえないが零年次を用意している.
これにより在学生の進級処理以前に新入生を教務システムに連携する運用を可能にする.

```alloy
enum 年次 { 零年次, 一年次, 二年次, 三年次, 四年次 }
```

### 合否

合否判定を行う前の状態と,合否判定の対象外となるケースに対応するため,それぞれ未判定および対象外を用意する.

```alloy
enum 合否区分 { 未判定, 合格, 不合格, 対象外 }
```

### 出欠区分

実際に受験したかどうかの出欠区分として,試験日が未到来による初期状態として未実施を用意している.

```alloy
enum 出席区分 { 未実施, 出席, 欠席 }
```

## 試験科目

試験の科目を表現するモデル.

```alloy
sig 科目{
}
```
