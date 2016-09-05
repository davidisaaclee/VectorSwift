import Foundation

/// A dimensional data structure.
public protocol Vector: Collection, Ring {
	typealias Scalar = Iterator.Element

	associatedtype Iterator = IndexingIterator<Self>

	/// The type which represents this vector type's length or magnitude.
	associatedtype LengthType

	/// Common initializer for vectors, allowing conversion among similar vector types.
	init<T>(collection: T) where T: Collection, T.Iterator.Element == Self.Scalar

	/// How many dimensions does this vector have?
	var numberOfDimensions: Int { get }

	/// The magnitude of the vector.
	var magnitude: LengthType { get }

	/// The squared magnitude of the vector.
	var squaredMagnitude: LengthType { get }

	/// A unit vector pointing in this vector's direction.
	var unit: Self { get }

	/// The negation of this vector, which points in the opposite direction as this vector, with an equal magnitude.
	var negative: Self { get }

	/// Produces a vector by translating one vector by another of a similar type.
	func sum<V: Vector>(_ operand: V) -> Self where V.Scalar == Self.Scalar


	/// Produces a vector by scaling this vector by a scalar.
	func scale(_ scalar: Self.Iterator.Element) -> Self

	/// Produces a vector by performing a piecewise multiplication of this vector by another vector.
	func piecewiseMultiply(_ vector: Self) -> Self
	func piecewiseMultiply<V: Vector>(_ vector: V) -> Self where V.Scalar == Self.Scalar
	func piecewiseMultiply<V: Vector>(_ vector: V) -> V where V.Scalar == Self.Scalar


	// MARK: - Methods with default implementations

	/// Produces a vector by translating one vector by another.
	static func + (randl: Self, randr: Self) -> Self
	static func + <V: Vector>(randl: Self, randr: V) -> Self where V.Scalar == Self.Scalar
    static func + <V: Vector>(randl: V, randr: Self) -> Self where V.Scalar == Self.Scalar

	/// Produces a vector by scaling a vector by a scalar.
	static func * (vector: Self, scalar: Scalar) -> Self
	static func * (scalar: Scalar, vector: Self) -> Self

	/// Produces a vector by multiplying two vectors piecewise.
	static func * (lhs: Self, rhs: Self) -> Self
	static func * <V: Vector>(randl: Self, randr: V) -> Self where V.Scalar == Self.Scalar
	static func * <V: Vector>(randl: V, randr: Self) -> Self where V.Scalar == Self.Scalar

	/// Produces a vector by translating the right-hand vector by the negation of the left-hand vector.
	static func - (randl: Self, randr: Self) -> Self
	static func - <V: Vector>(randl: Self, randr: V) -> Self where V.Scalar == Self.Scalar
	static func - <V: Vector>(randl: V, randr: Self) -> Self where V.Scalar == Self.Scalar

	/// Negates a vector.
	prefix static func - (rand: Self) -> Self
}


// MARK: - Aliases

public extension Vector {
	public var normalized: Self {
		return self.unit
	}

	public var length: Self.LengthType {
		return self.magnitude
	}

	public func distanceTo(_ vector: Self) -> Self.LengthType {
		return (vector - self).magnitude
	}

	public func distanceTo<V: Vector>(_ vector: V) -> Self.LengthType where V.Scalar == Self.Scalar {
		return self.distanceTo(Self(collection: vector))
	}
}


// MARK: - Default implementations

public extension Vector {
	public func makeIterator() -> IndexingIterator<Self> {
		return IndexingIterator(_elements: self)
	}

    public static func + (randl: Self, randr: Self) -> Self {
        return randl.sum(randr)
    }

    public static func + <V: Vector> (randl: Self, randr: V) -> Self where Self.Scalar == V.Scalar {
        return randl.sum(randr)
    }

    public static func + <V: Vector> (randl: V, randr: Self) -> Self where Self.Scalar == V.Scalar {
        return randr.sum(randl)
    }


    public static func * (vector: Self, scalar: Scalar) -> Self {
        return vector.scale(scalar)
    }

    public static func * (scalar: Scalar, vector: Self) -> Self {
        return vector.scale(scalar)
    }


    public static func * (randl: Self, randr: Self) -> Self {
        return randl.piecewiseMultiply(randr)
    }

    public static func * <V: Vector> (randl: Self, randr: V) -> Self where Self.Scalar == V.Scalar {
        return randl.piecewiseMultiply(randr)
    }

    public static func * <V: Vector> (randl: V, randr: Self) -> Self where Self.Scalar == V.Scalar {
        return randl.piecewiseMultiply(randr)
    }


    public static func - (randl: Self, randr: Self) -> Self {
        return randl.sum(randr.negative)
    }

    public static func - <V: Vector> (randl: Self, randr: V) -> Self where Self.Scalar == V.Scalar {
        return randl.sum(randr.negative)
    }

    public static func - <V: Vector> (randl: V, randr: Self) -> Self where Self.Scalar == V.Scalar {
        return randr.negative.sum(randl)
    }
    
    
    public static prefix func - (rand: Self) -> Self {
        return rand.negative
    }
}

public extension Vector where Self.Index == Int {
	public var startIndex: Int {
		return 0
	}

	public var endIndex: Int {
		return self.numberOfDimensions
	}
}




public extension Vector where Self: Equatable, Self.Scalar: Equatable {}
public func == <V: Vector>(lhs: V, rhs: V) -> Bool where V.Scalar: Equatable {
	if lhs.count != rhs.count {
		return false
	}

	return zip(lhs, rhs)
		.map { $0.0 == $0.1 }
		.reduce(true) { $0 && $1 }
}


// MARK: - Default implementations for specific element types

public extension Vector where Self.Iterator.Element: Ring {
	public func sum(_ operand: Self) -> Self {
		return Self(collection: Array(zip(self, operand).map { $0 + $1 }))
	}

	public func sum<V: Vector>(_ operand: V) -> Self where V.Scalar == Self.Scalar {
		return Self(collection: Array(zip(self, operand).map { $0 + $1 }))
	}

	public func sum<V: Vector>(_ operand: V) -> V where V.Scalar == Self.Scalar {
		return V(collection: Array(zip(self, operand).map { $0 + $1 }))
	}

	public func scale(_ scalar: Scalar) -> Self {
		return Self(collection: self.map { $0 * scalar })
	}

	public func piecewiseMultiply(_ vector: Self) -> Self {
		return Self(collection: zip(self, vector).map { (lhs, rhs) in lhs * rhs })
	}

	public func piecewiseMultiply <V: Vector> (_ vector: V) -> Self where V.Scalar == Self.Scalar {
		return Self(collection: zip(self, vector).map { (lhs, rhs) in lhs * rhs })
	}

	public func piecewiseMultiply <V: Vector> (_ vector: V) -> V where V.Scalar == Self.Scalar {
		return V(collection: zip(self, vector).map { (lhs, rhs) in lhs * rhs })
	}

	public var squaredMagnitude: Scalar {
		return self.reduce(Scalar.additionIdentity) { $0 + $1 * $1 }
	}
}

public extension Vector where Iterator.Element: Field, LengthType == Self.Iterator.Element {
	public var magnitude: LengthType {
		return self.squaredMagnitude.toThePowerOf(0.5)
	}

	public var unit: Self {
		return self * (LengthType.multiplicationIdentity / self.magnitude)
	}

	public var negative: Self {
		return self * -1.0
	}
}
