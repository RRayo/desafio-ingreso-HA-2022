'use client'
import React, { useEffect, useState } from 'react';

export default function Home() {
  const [selectedOption, setSelectedOption] = useState('');
  const [inputValue, setInputValue] = useState('');

  type Item = {
    resource: string;
    quantity: string;
    date: Date;
  };
  const [items, setItems] = useState<Item[]>([]);

  useEffect(() => {
    setSelectedOption('');
  }, []);

  const handleChange = (event: { target: { value: React.SetStateAction<string>; }; }) => {
    setSelectedOption(event.target.value);
  };

  const handleInputChange = (event: { target: { value: React.SetStateAction<string>; }; }) => {
    const newValue = event.target.value;
    if (Number.isInteger(Number(newValue)) && Number(newValue) >= 1) {
      setInputValue(newValue);
    }
  };

  const handleIngresarClick = () => {
    if (selectedOption && inputValue) {
      // Add the new item
      const newItem = {
        resource: selectedOption,
        quantity: inputValue,
        date: new Date(),
      };
      setItems([...items, newItem]);
  
      // Reset the selected option and input value
      setSelectedOption("");
      setInputValue("");
    }
  };

  const handleDeleteClick = (index: number) => {
    setItems(prevItems => prevItems.filter((item, i) => i !== index));
  };

  const units: Record<string, string> = {
    option1: 'ml',
    option2: 'g',
    option3: 'ml',
    option4: 'unidades',
    option5: 'unidades',
  };

  const resources: Record<string, string> = {
    option1: 'Agua',
    option2: 'Pólvora',
    option3: 'Gas',
    option4: 'Hojas (filo)',
    option5: 'Equipo maniobras',
  };

  return (
    <main className="flex min-h-screen items-center justify-center p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex flex-col">
        <div className="flex flex-col items-center justify-center h-full">
        <div className={items.length > 0 ? 'flex-row gap-2' : 'flex-col items-center self-center mb-4'}>
          {selectedOption && items.length == 0 && (
            <>
              <div className="flex-row items-center self-center mb-4">
                <input type="number" value={inputValue} onChange={handleInputChange} className="mr-2" />
                <span>{units[selectedOption]}</span>
              </div>
            </>
          )}
          <select value={selectedOption} onChange={handleChange} className="self-center mb-4">
            <option value="">Selecciona Recurso</option>
            <option value="option1">Agua</option>
            <option value="option2">Pólvora</option>
            <option value="option3">Gas</option>
            <option value="option4">Hojas (filo)</option>
            <option value="option5">Equipo maniobras</option>
          </select>
          {selectedOption && items.length == 0 && (
            <>
              <div className="flex items-center self-end mb-4 justify-end">
                <button className="flex self-center" onClick={handleIngresarClick}>Ingresar</button>
              </div>
            </>
          )}
          {items.length > 0 && (
            <>
              <div className="flex-row items-center self-center mb-4 gap-2">
                <input type="number" value={inputValue} onChange={handleInputChange} />
                <span>{units[selectedOption]}</span>
              </div>
              <div className="flex items-center self-center mb-4">
                <button className="self-center" onClick={handleIngresarClick}>Ingresar</button>
              </div>
            </>
          )}
        </div>

          {items.length > 0 && (
            <>
              <div className="grid grid-cols-4 gap-4">
                <div className="border-r border-b border-black p-2">Recurso</div>
                <div className="border-r border-b border-black p-2">Cantidad</div>
                <div className="border-r border-b border-black p-2">Fecha de ingreso</div>
                <div className="border-b border-black  p-2">Eliminar</div>

                {items.map((item, index) => (
                  <React.Fragment key={index}>
                    <div className="border-r border-black p-2">{resources[item.resource]}</div>
                    <div className="border-r border-black p-2">{item.quantity}</div>
                    <div className="border-r border-black p-2">{item.date.toLocaleDateString()}</div>
                    <div className="flex justify-center border-black p-2">
                      <button onClick={() => handleDeleteClick(index)} className='border-0'>
                        <span className="self-center">🗑️</span>
                      </button>
                    </div>
                  </React.Fragment>
                ))}
              </div>
            </>
          )}
          
        </div>
      </div>
    </main>
  );
}