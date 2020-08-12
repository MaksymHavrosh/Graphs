# Нужно создать класс который будет рисовать график исходя из модели

class MyChart: UIView {

    override draw() {
    }
}

## Требования
- В этом классе нельзя использовать новые UIView(), т.е. все должно рисоваться руками в draw()
- В графике должно быть динамическое кол-во колонок в зависимости от переданной модели. 
- График всегда должен быть на всю ширину экрана с маленькими отступами справа и слева (высота на твое усмотрение), соответственно колонки так же должны динамически менять ширину. 
- Поддержка portrait/landscape ориентаций
- График должен отрисоваться с модели A, через 5 сек все колонки должны анимационно измениться под модель B (модели можно использовать хардкодом или генерить value рандомно от minValue до maxValue, в них должен быть color и value. minValue = 0, maxValue = 100).
- Желательно не пользоваться frame-ами там где это возможно
- Желательно использовать CAShapeLayer 
- При клике на график он должен анимационно перерисовываться с текущей модели на следующую по кругу.
A => B => A => B ...
- Storyboard использовать нельзя

## P.S.
Для constraint желательно использовать SnapKit, но не обязательно.