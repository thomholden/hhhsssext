#ifndef  __templates_h__
#define  __templates_h__

#include "util.h"

class slice {
public:
    slice(int begin, int size) {
        m_begin = begin;
        m_size = size;
    }

    int m_begin, m_size;
};

//***********************************//
//** A simple array template class **//
//***********************************//
template <class T> class Array {
public:
	Array(int init_size=0, T init_val=(T)0, int grow_by=128);
    Array(T* a, int asize, int grow_by=128);
    Array(const Array<T>& x);
	virtual ~Array();

    Array<T>& operator=(const Array<T>& x) {
        copy(x);
        return *this;
    }
	// Properties
    int size() const { return m_size; }
	void set_size(int size) { resize(size); }

	T& operator[] (int index);              // lhs
    T operator[] (int index) const;
    Array<T> operator[] (slice sl) const;   // rhs only
	void add(T d) {
		resize(m_size+1);
		m_data[m_size-1] = d;
	}
	int remove(int index);
	void copy(const Array& src);
    void set(const Array& src, int begin, int end);
    
    Array<T>& fill(T val, int begin=0, int end=-1);
    Array<T>& shift(int _shift, T fillwith = (T)0);

	// File I/O
	int file_read(FILE* fp, int size);
	int file_write(FILE* fp, int begin=0, int end=-1);

	// Memory management
	void free_extra() {
		resize(m_size, true);
	}
private:
	void resize(int size, bool force=false);
	void delete_array() {
		if (m_data != null) { delete [] m_data; }
	}
	int get_alloc_size(int size) {
		int alloc_size = (size/m_grow_by)*m_grow_by;
		return (alloc_size >= size) ? alloc_size : alloc_size + m_grow_by;
	}
	T* m_data;
	int m_size;
	int m_alloc_size;
	int m_grow_by;

	enum { def_extra_mem=1024, def_grow_by=128 };
};

template <class T> Array<T>::Array(int init_size,
                                   T init_val,
								   int grow_by) {
	m_grow_by = grow_by;
	m_alloc_size = 0;
	m_size = 0;
	m_data = 0;
	if (init_size > 0) {
		resize(init_size);
        if (init_val != ((T)0)) {
            fill(init_val);
        }
	}
}

template <class T> Array<T>::Array(T* a,
                                   int asize,
                                   int grow_by) {
	m_grow_by = grow_by;
	m_alloc_size = 0;
	m_size = 0;
	m_data = 0;
	if (asize > 0) {
		resize(asize);
    }
    for (int i=0; i<asize; ++i) {
        m_data[i] = a[i];
    }
}


template <class T> Array<T>::Array(const Array<T>& x) {
    m_alloc_size = 0;
    m_size = 0;
    m_data = 0;
    m_grow_by = x.m_grow_by;
    copy(x);
}

// virtual
template <class T> Array<T>::~Array() {
	delete_array();
}

template <class T> T& Array<T>::operator[] (int index) {
	_ASSERTE(index >= 0);
	_ASSERTE(index < m_size);
	return m_data[index];
}

template <class T> T Array<T>::operator[] (int index) const {
	_ASSERTE(index >= 0);
	_ASSERTE(index < m_size);
	return m_data[index];
}

// return a slice or sub-array
template <class T> Array<T> Array<T>::operator[] (slice sl) const {
    Array<T> retarray;
    int begin = sl.m_begin;
    _ASSERTE(begin >= 0);
    int len = sl.m_size;
    _ASSERTE((begin+len)<=m_size);
    retarray.set_size(len);
    int i;
    for (i=0;i<len;i++) {
        retarray[i] = m_data[i+begin];
    }
    return retarray;
}

// Fill from begin to end with value 'val'
template <class T> Array<T>& Array<T>::fill(T val,
                                            int begin,
                                            int end) {
    _ASSERTE(begin >= 0);
    _ASSERTE(begin < m_size);
    if (end == -1) { end = m_size-1; }
    _ASSERTE(end >= 0);
    _ASSERTE(end < m_size);
    _ASSERTE(end >= begin);
    for (int i=begin; i<=end; i++) { m_data[i] = val; }
    return *this;
}

// Move values from location 'i' to location 'i+_shift'
template <class T> Array<T>& Array<T>::shift(int _shift,
                                             T fillwith) {
    int i;
    if (_shift < 0) {
        for (i=m_size-1; i>=-_shift; --i) {
            m_data[i] = m_data[i+_shift];
        }
        fill(fillwith,0,-(_shift+1));
    } else if (_shift > 0) {
        for (i=0; i<m_size-_shift; ++i) {
            m_data[i] = m_data[i+_shift];
        }
        fill(fillwith,m_size-_shift,m_size-1);
    }
    return *this;
}


template <class T> int Array<T>::remove(int index) {
	if ((index < 0) || (index >= m_size)) {
		_ASSERTE((index >= 0) && (index < m_size));
		return m_size;
	}
	for (int i=index; i<(m_size-1); ++i) {
		m_data[i] = m_data[i+1];
	}
	resize(m_size-1);
	return size();
}

template <class T> void Array<T>::copy(const Array& src) {
	set_size(src.size());
	for (int i=0; i<src.size(); ++i) {
		m_data[i] = src.m_data[i];
	}
}

template <class T> void Array<T>::set(const Array& src,
                                      int begin,
                                      int end) {
    _ASSERTE(begin >= 0);
    _ASSERTE(begin < size());
    _ASSERTE(end < size());
    _ASSERTE(end >= begin);
    _ASSERTE((end-begin+1) == src.size());
    for (int i=0; i<src.size(); ++i) {
        m_data[begin+i] = src[i];
    }
}


template <class T> void Array<T>::resize(int size,
										 bool force) {
	if ((size > m_alloc_size) || force) {
		m_alloc_size = get_alloc_size(size);
#ifdef _DEBUG
#endif //_DEBUG
		T* data = new T[m_alloc_size];
		int copy_size = min(size, m_size);
        int i;
		for (i=0; i<copy_size; ++i) {
			data[i] = m_data[i];
		}
        for (i=copy_size; i<m_alloc_size; i++) {
            data[i] = (T)0;
        }
		delete_array();
		m_data = data;
	}
	m_size = size;
}

template <class T> int Array<T>::file_read(FILE* fp,
											int size) {
	_ASSERTE(size > 0);

	resize(size);
	int read_count = fread((void*)m_data, sizeof(T), size, fp);
	if (read_count != size) {
		resize(read_count);
	}
	return read_count;
}

template <class T> int Array<T>::file_write(FILE* fp,
											 int begin,
											 int end) {
	_ASSERTE(begin >= 0);
	_ASSERTE(end < m_size);
	_ASSERTE(begin <= end);
	if (end < 0) {
		end = m_size-1;
	}
	int write_count = fwrite((void*)(m_data+begin), sizeof(T), end-begin+1, fp);
	return write_count;
}

template <class T>
Array<T> operator*(const Array<T>& _L,
                   const T& _R) {
    Array<T> retarray(_L);
    for (int i=0; i<retarray.size(); ++i) {
        retarray[i] *= _R;
    }
    return retarray;
}

template <class T> inline
Array<T> operator*(const T& _L,
                   const Array<T>& _R) {
    Array<T> retarray(_R);
    for (int i=0; i<retarray.size(); ++i) {
        retarray[i] *= _L;
    }
    return retarray;
}

template <class T> inline
Array<T> operator+(const Array<T>& _L,
                   const Array<T>& _R) {
    Array<T> retarray(_L);
    for (int i=0; i<retarray.size(); ++i) {
        retarray[i] += _R[i];
    }
    return retarray;
}

#endif //__templates_h__

